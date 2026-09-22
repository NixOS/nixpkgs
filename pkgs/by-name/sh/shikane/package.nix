{
  lib,
  rustPlatform,
  fetchFromGitLab,
  installShellFiles,
  pandoc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shikane";
  version = "1.1.1";

  src = fetchFromGitLab {
    owner = "w0lff";
    repo = "shikane";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gh85a070R4SooghtvumfSED1H12JtOksj7Yk/WHnWck=";
  };

  cargoHash = "sha256-XKx6jTSAoCC4BM6kmeeEymzRzga15uyIuTxqtdQnru8=";

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
