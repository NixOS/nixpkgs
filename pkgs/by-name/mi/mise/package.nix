{
  stdenv,
  lib,
  nix-update-script,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  writeShellScript,
  coreutils,
  bash,
  direnv,
  gitMinimal,
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

let
  copyProbe = writeShellScript "mise-copy-probe" ''
    exec ${lib.getExe' coreutils "cp"} "$@"
  '';

  codesignStub = writeShellScript "mise-codesign-stub" ''
    for arg; do bundle=$arg; done
    mkdir -p "$bundle/Contents/_CodeSignature"
    : > "$bundle/Contents/_CodeSignature/CodeResources"
  '';
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mise";
  version = "2026.9.3";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "mise";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o61fIIVKJrZd36O3sc1O9lEEoHMPH1sryasLXNckLWQ=";
  };

  cargoHash = "sha256-22i9pURiN3CGgFRmG4VptpdR1MIryd3sCxtxOx9SMZA=";

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
      --replace-fail '"git"' '"${lib.getExe gitMinimal}"'

    substituteInPlace ./src/env_diff.rs \
      --replace-fail '"bash"' '"${lib.getExe bash}"'

    substituteInPlace ./src/cli/direnv/exec.rs \
      --replace-fail '"env"' '"${lib.getExe' coreutils "env"}"' \
      --replace-fail 'cmd!("direnv"' 'cmd!("${lib.getExe direnv}"'

    # the age plugin protocol test writes this fixture out and executes it
    substituteInPlace ./src/agecrypt/fixtures/age-plugin-se.py \
      --replace-fail '#!/usr/bin/env python3' '#!${lib.getExe python3}'

    # /bin/cp is not in the sandbox, and it is both the probe's symlink target
    # and the file the probe is asked to copy
    substituteInPlace ./src/backend/spm.rs \
      --replace-fail '/bin/cp' '${copyProbe}'

    # tests that clear the environment and rebuild a minimal system PATH
    substituteInPlace ./src/cmd.rs ./src/inline_command.rs \
      --replace-fail '.env("PATH", "/usr/bin:/bin")' '.env("PATH", "${lib.getBin coreutils}/bin:/usr/bin:/bin")'

    substituteInPlace ./src/inline_command.rs \
      --replace-fail 'Command::new("/bin/sh")' 'Command::new("${lib.getExe' bash "sh"}")'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''

    substituteInPlace ./build.rs \
      --replace-fail '/usr/bin/codesign' '${codesignStub}'
  '';

  nativeCheckInputs = [
    cacert
    cmake
    # gix spawns git-upload-pack by name in file:// clone tests.
    gitMinimal
    rustPlatform.bindgenHook
  ];

  env = {
    # disable warnings as errors for aws-lc-sys in checkPhase
    NIX_CFLAGS_COMPILE = "-Wno-error";
    # tera date helper tests look up timezone data via TZDIR.
    TZDIR = "${tzdata}/share/zoneinfo";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # the notification helper is never Developer ID signed here
    MISE_NOTIFICATION_SIGN_IDENTITY = "-";
  };

  checkFlags = [
    # last_modified will always be different in nix
    "--skip=tera::tests::test_last_modified"
    # bootstrapping node-gyp through aube requires network access
    "--skip=mise_binary_services_aube_node_gyp_bootstrap_trampoline"
    # we don't care about brew tests and a lot of them fails here
    "--skip=system::packages::brew::cask::tests::"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    # talk to the macOS preferences store, which is unreachable in the sandbox
    "--skip=system::defaults::tests::test_status_missing_keys_are_unset"
    "--skip=system::defaults::tests::test_nested_value_round_trip"
    # the notification helper will not work on macos without codesigned bundle
    "--skip=system::history::notify::macos::tests::"
    # sandbox-exec is unavailable inside the darwin sandbox
    "--skip=cmd::tests::test_macos_sandbox_preserves_piped_stdin"
    "--skip=sandbox::macos::tests::"
  ];

  cargoTestFlags = [ "--all-features" ];
  # some tests access the same folders, don't test in parallel to avoid race conditions
  dontUseCargoParallelTests = true;

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
