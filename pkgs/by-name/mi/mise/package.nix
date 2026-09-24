{
  stdenv,
  lib,
  nix-update-script,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  coreutils,
  bash,
  direnv,
  git,
  pkg-config,
  openssl,
  cmake,
  cacert,
  tzdata,
  python3,
  usage,
  testers,
  runCommand,
  jq,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mise";
  version = "2026.9.13";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "mise";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kl576zWsww9cOOX41e14uDkr5Zcig7Pp/iXmNqBR+lI=";
  };

  cargoHash = "sha256-QgoMmPXsKCdNnepfYusJza+7z0zQNmaNVzKTw36qesk=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];

  buildInputs = [ openssl ];

  postPatch = ''
    patchShebangs --build \
      ./test/data/plugins/**/bin/* \
      ./src/fake_asdf.rs \
      ./src/cli/generate/git_pre_commit.rs \
      ./src/cli/generate/snapshots/*.snap

    substituteInPlace ./src/test.rs \
      --replace-fail '/usr/bin/env bash' '${lib.getExe bash}'

    substituteInPlace ./src/git.rs \
      --replace-fail '"git"' '"${lib.getExe git}"'

    substituteInPlace ./src/env_diff.rs \
      --replace-fail '"bash"' '"${lib.getExe bash}"'

    substituteInPlace ./src/cli/direnv/exec.rs \
      --replace-fail '"env"' '"${lib.getExe' coreutils "env"}"' \
      --replace-fail 'cmd!("direnv"' 'cmd!("${lib.getExe direnv}"'

    # tests spawn helpers with PATH=/usr/bin:/bin, which is near-empty here
    substituteInPlace ./src/cmd.rs \
      --replace-fail '.env("PATH", "/usr/bin:/bin")' '.env("PATH", "${lib.getBin coreutils}/bin:/usr/bin:/bin")'

    substituteInPlace ./src/inline_command.rs \
      --replace-fail '.env("PATH", "/usr/bin:/bin")' '.env("PATH", "${lib.getBin coreutils}/bin:/usr/bin:/bin")' \
      --replace-fail 'Command::new("/bin/sh")' 'Command::new("${lib.getExe' bash "sh"}")'

    substituteInPlace ./src/agecrypt/fixtures/age-plugin-se.py \
      --replace-fail '#!/usr/bin/env python3' '#!${lib.getExe python3}'
  '';

  nativeCheckInputs = [
    cacert
    cmake
    coreutils
    # gix spawns git-upload-pack by name in file:// clone tests.
    git
    python3
    rustPlatform.bindgenHook
  ];

  env = {
    # disable warnings as errors for aws-lc-sys in checkPhase
    NIX_CFLAGS_COMPILE = "-Wno-error";
    # tera date helper tests look up timezone data via TZDIR.
    TZDIR = "${tzdata}/share/zoneinfo";
    # the other profiles' 250ms slow-timeout kills tests on loaded builders
    NEXTEST_PROFILE = "ci-shared";
  };

  # the suite assumes nextest's process-per-test model: tests move or unlink
  # the process cwd, which strands later tests in a shared `cargo test` process
  useNextest = true;

  # nextest's libtest emulation takes `--skip PATTERN`, not `--skip=`
  checkFlags = [
    # last_modified will always be different in nix
    "--skip"
    "tera::tests::test_last_modified"
    # bootstrapping node-gyp through aube requires network access
    "--skip"
    "mise_binary_services_aube_node_gyp_bootstrap_trampoline"
    # we don't care about brew tests and a lot of them fails here
    "--skip"
    "system::packages::brew::cask::tests::"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    # shell out to macOS system binaries that the darwin sandbox refuses to exec
    "--skip"
    "system::defaults::tests::test_status_missing_keys_are_unset"
    # need a running cfprefsd
    "--skip"
    "system::defaults::tests::test_dock_apps_native_round_trip"
    "--skip"
    "system::defaults::tests::test_host_scopes_are_independent"
    "--skip"
    "system::defaults::tests::test_nested_value_round_trip"
    "--skip"
    "system::defaults::tests::test_patch_native_round_trip_and_preflight"
    # sandbox-exec is unavailable in the sandbox
    "--skip"
    "sandbox::macos::tests::"
    "--skip"
    "cmd::tests::test_macos_sandbox_preserves_piped_stdin"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    # un_dmg shells out to hdiutil
    "--skip"
    "file::tests::un_dmg_accepts_license_and_extracts_app"
    "--skip"
    "file::tests::un_dmg_extracts_app_without_license"
    # the copy probe symlinks /bin/cp, which the sandbox does not provide
    "--skip"
    "backend::spm::tests::test_inline_install_command_uses_install_environment"
    # chmods setuid, which the sandbox refuses
    "--skip"
    "system_install::tests::archive_boundary"
  ];

  # every test process resets the same fixed $HOME/cwd
  dontUseCargoParallelTests = true;

  cargoTestFlags = [
    "--all-features"
    "--no-fail-fast"
  ];

  # HTTP tests use mock servers that bind to localhost. Without this, darwin builds fail.
  __darwinAllowLocalNetworking = true;

  postInstall = ''
    installManPage ./man/man1/mise.1

    installShellCompletion \
      --bash ./completions/mise.bash \
      --fish ./completions/mise.fish \
      --zsh ./completions/_mise

    mkdir -p $out/lib/mise
    touch $out/lib/mise/.disable-self-update
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        # Ignore subcrate releases (fox, aqua-registry)
        "--version-regex=^v([0-9]+\\.[0-9]+\\.[0-9]+)$"
      ];
    };
    tests = {
      version = (testers.testVersion { package = finalAttrs.finalPackage; }).overrideAttrs (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ cacert ];
      });
      usageCompat =
        # should not crash
        runCommand "mise-usage-compatibility"
          {
            nativeBuildInputs = [
              finalAttrs.finalPackage
              usage
              jq
            ];
          }
          ''
            export HOME=$(mktemp -d)

            for shl in bash fish zsh; do
              echo "testing $shl"
              usage complete-word --shell $shl --file <(mise usage)
            done

            touch $out
          '';
    };
  };

  meta = {
    homepage = "https://mise.jdx.dev";
    description = "Front-end to your dev env";
    changelog = "https://github.com/jdx/mise/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      konradmalik
      Br1ght0ne
    ];
    mainProgram = "mise";
  };
})
