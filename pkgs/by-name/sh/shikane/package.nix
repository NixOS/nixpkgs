{
  lib,
  rustPlatform,
  fetchFromGitLab,
  installShellFiles,
  pandoc,
}:

rustPlatform.buildRustPackage rec {
  pname = "shikane";
  version = "1.0.1";

  src = fetchFromGitLab {
    owner = "w0lff";
    repo = "shikane";
    rev = "v${version}";
    hash = "sha256-Chc1+JUHXzuLl26NuBGVxSiXiaE4Ns1FXb0dBs6STVk=";
  };

  cargoHash = "sha256-eVEfuX/dNFoNH9o18fIx51DP/MWrQMqInU4wtGCmUbQ=";

  nativeBuildInputs = [
    installShellFiles
    pandoc
  ];

  postBuild = ''
    bash ./scripts/build-docs.sh man
  '';

  postInstall = ''
    installManPage ./build/shikane.*
  '';

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Dynamic output configuration tool that automatically detects and configures connected outputs based on a set of profiles";
    homepage = "https://gitlab.com/w0lff/shikane";
    changelog = "https://gitlab.com/w0lff/shikane/-/tags/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      michaelpachec0
      natsukium
    ];
    platforms = lib.platforms.linux;
    mainProgram = "shikane";
  };
}
