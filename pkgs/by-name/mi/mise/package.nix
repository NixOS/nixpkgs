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
  usage,
  mise,
  testers,
  runCommand,
  jq,
}:

rustPlatform.buildRustPackage rec {
  pname = "mise";
  version = "2025.11.11";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "mise";
    rev = "v${version}";
    hash = "sha256-Qvxh3mxT6Eb2T2x83TonlmdBdmor5AqbVadUUG9p1o8=";
  };

  cargoHash = "sha256-G2cLBPKXkK6LcK2wGIknz9TH2RGndmc4/3oq/QKkw2c=";

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
    rustPlatform.bindgenHook
  ];

  # disable warnings as errors for aws-lc-sys in checkPhase
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  checkFlags = [
    # last_modified will always be different in nix
    "--skip=tera::tests::test_last_modified"
  ]
  ++ lib.optionals (stdenv.hostPlatform.system == "x86_64-darwin") [
    # started failing mid-April 2025
    "--skip=task::task_file_providers::remote_task_http::tests::test_http_remote_task_get_local_path_with_cache"
    "--skip=task::task_file_providers::remote_task_http::tests::test_http_remote_task_get_local_path_without_cache"
  ];

  cargoTestFlags = [ "--all-features" ];
  # some tests access the same folders, don't test in parallel to avoid race conditions
  dontUseCargoParallelTests = true;

  postInstall = ''
    installManPage ./man/man1/mise.1

    substituteInPlace ./completions/{mise.bash,mise.fish,_mise}  \
      --replace-fail '-p usage' '-p ${lib.getExe usage}' \
      --replace-fail 'usage complete-word' '${lib.getExe usage} complete-word'

    installShellCompletion \
      --bash ./completions/mise.bash \
      --fish ./completions/mise.fish \
      --zsh ./completions/_mise

    mkdir -p $out/lib/mise
    touch $out/lib/mise/.disable-self-update
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = (testers.testVersion { package = mise; }).overrideAttrs (old: {
        nativeBuildInputs = old.nativeBuildInputs ++ [ cacert ];
      });
      usageCompat =
        # should not crash
        runCommand "mise-usage-compatibility"
          {
            nativeBuildInputs = [
              mise
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
    changelog = "https://github.com/jdx/mise/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ konradmalik ];
    mainProgram = "mise";
  };
}
