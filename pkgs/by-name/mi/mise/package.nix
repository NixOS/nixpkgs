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
  cacert,
  usage,
  mise,
  testers,
  runCommand,
  jq,
}:

rustPlatform.buildRustPackage rec {
  pname = "mise";
  version = "2025.10.7";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "mise";
    rev = "v${version}";
    hash = "sha256-Ccc2kYQa0LkLKuQEV4bOSbMU/IHkUVQdtSVmiCSWeyc=";
  };

  cargoHash = "sha256-/wv7moY3Ix0+Kxk8gI7fsaeX6O5oB1H/ugUBaBHyTSw=";

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

  nativeCheckInputs = [ cacert ];

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
      --replace-fail '-v usage' '-v ${lib.getExe usage}' \
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

            spec="$(mise usage)"
            for shl in bash fish zsh; do
              echo "testing $shl"
              usage complete-word --shell $shl --spec "$spec"
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
