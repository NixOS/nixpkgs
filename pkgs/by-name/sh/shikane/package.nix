{
  lib,
  rustPlatform,
  fetchFromGitLab,
  installShellFiles,
  pandoc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shikane";
  version = "1.1.0";

  src = fetchFromGitLab {
    owner = "w0lff";
    repo = "shikane";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YjHFhGP2A8dQTOmeeBqB2ij3Zgs0n/uuisvWTH8fyfQ=";
  };

  cargoHash = "sha256-ajmEbE5Y4LkxvYRFE6aBDZxNpGULTmKeu6/k92kWjQg=";

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  postBuild = ''
    bash ./scripts/build-docs.sh man
  '';

  postInstall = ''
    installManPage ./build/man/*
  '';

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Dynamic output configuration tool that automatically detects and configures connected outputs based on a set of profiles";
    homepage = "https://gitlab.com/w0lff/shikane";
    changelog = "https://gitlab.com/w0lff/shikane/-/tags/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      michaelpachec0
      natsukium
    ];
    platforms = lib.platforms.linux;
    mainProgram = "shikane";
  };
})
