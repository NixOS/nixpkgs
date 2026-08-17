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
  usage,
  testers,
  runCommand,
  jq,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mise";
  version = "2026.8.6";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "mise";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dm+cIb6i+npYSIUfxaEi3ohumeT9lXXlQwYREndwZFE=";
  };

  cargoHash = "sha256-VzRNo2fa4n4oOw27itjFebKpIhSdm8UmI/xdBBJIh9g=";

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
  '';

  nativeCheckInputs = [
    cacert
    cmake
    # gix spawns git-upload-pack by name in file:// clone tests.
    git
    rustPlatform.bindgenHook
  ];

  env = {
    # disable warnings as errors for aws-lc-sys in checkPhase
    NIX_CFLAGS_COMPILE = "-Wno-error";
    # tera date helper tests look up timezone data via TZDIR.
    TZDIR = "${tzdata}/share/zoneinfo";
  };

  checkFlags = [
    # last_modified will always be different in nix
    "--skip=tera::tests::test_last_modified"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    # shell out to macOS system binaries that the darwin sandbox refuses to exec
    "--skip=system::defaults::tests::test_status_missing_keys_are_unset"
    # we don't care about brew tests and a lot of them fails here
    "--skip=system::packages::brew::cask::tests::"
  ];

  cargoTestFlags = [ "--all-features" ];
  # some tests access the same folders, don't test in parallel to avoid race conditions
  dontUseCargoParallelTests = true;

  # HTTP tests use mock servers that bind to localhost. Without this, darwin builds fail.
  __darwinAllowLocalNetworking = true;

  postInstall = ''
    installManPage ./man/man1/mise.1

    substituteInPlace ./completions/{mise.bash,mise.fish,_mise}  \
      --replace-fail 'usage &> /dev/null' '${lib.getExe usage} &> /dev/null' \
      --replace-fail 'usage complete-word' '${lib.getExe usage} complete-word'

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
