{
  lib,
  nix-update-script,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
  coreutils,
  bash,
  direnv,
  git,
  pkg-config,
  openssl,
  Security,
  SystemConfiguration,
  usage,
  mise,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "mise";
  version = "2024.10.7";

  src = fetchFromGitHub {
    owner = "jdx";
    repo = "mise";
    rev = "v${version}";
    hash = "sha256-VOx2QsrlqZXO7B1he8DHNmGffcICAENL8YKE7IiBPwM=";

    # registry is not needed for compilation nor for tests.
    # contains files with the same name but different case, which cause problems with hash on darwin
    postFetch = ''
      rm -rf $out/registry
    '';
  };

  cargoHash = "sha256-WcjIn2FgYQtcd1YU2SoeIjJOQuSWHqFcf0DjEpVYr1A=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
  ];
  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Security
      SystemConfiguration
    ];

  postPatch = ''
    patchShebangs --build \
      ./test/data/plugins/**/bin/* \
      ./src/fake_asdf.rs \
      ./src/cli/generate/git_pre_commit.rs \
      ./src/cli/generate/snapshots/*.snap

    substituteInPlace ./src/test.rs \
      --replace-fail '/usr/bin/env bash' '${lib.getExe bash}' \
      --replace-fail '"git"' '"${lib.getExe git}"'

    substituteInPlace ./src/git.rs \
      --replace-fail '"git"' '"${lib.getExe git}"'

    substituteInPlace ./src/env_diff.rs \
      --replace-fail '"bash"' '"${lib.getExe bash}"'

    substituteInPlace ./src/cli/direnv/exec.rs \
      --replace-fail '"env"' '"${lib.getExe' coreutils "env"}"' \
      --replace-fail 'cmd!("direnv"' 'cmd!("${lib.getExe direnv}"'
  '';

  checkFlags = [
    # last_modified will always be different in nix
    "--skip=tera::tests::test_last_modified"
    # requires https://github.com/rbenv/ruby-build
    "--skip=plugins::core::ruby::tests::test_list_versions_matching"
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
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = mise; };
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
