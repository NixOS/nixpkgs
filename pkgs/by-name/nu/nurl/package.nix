{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  gitMinimal,
  mercurial,
  nix,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nurl";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nurl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BxtvT2k4mErYPU9lNpZlat9ULI2wKXQToic7+PgkCSk=";
  };

  cargoHash = "sha256-4ACuHFzfuF4JWU0cPAJO+RPiA1HZ6o3b8K0C4NWJHmM=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  # disable tests that require internet access
  checkFlags = [
    "--skip=integration"
    "--skip=verify_outputs"
  ];

  postInstall = ''
    wrapProgram $out/bin/nurl \
      --prefix PATH : ${
        lib.makeBinPath [
          gitMinimal
          mercurial
          nix
        ]
      }
    installManPage artifacts/nurl.1
    installShellCompletion artifacts/nurl.{bash,fish} --zsh artifacts/_nurl
  '';

  env = {
    GEN_ARTIFACTS = "artifacts";
  };

  meta = {
    description = "Command-line tool to generate Nix fetcher calls from repository URLs";
    homepage = "https://github.com/nix-community/nurl";
    changelog = "https://github.com/nix-community/nurl/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      figsoda
      matthiasbeyer
    ];
    mainProgram = "nurl";
  };
})
