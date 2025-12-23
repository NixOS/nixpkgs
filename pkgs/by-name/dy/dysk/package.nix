{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "dysk";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "dysk";
    tag = "v${version}";
    hash = "sha256-8bDCT+kIFkspRg3g7thXK1mD6pCJVLHwsUhGOLLVkow=";
  };

  cargoHash = "sha256-Twp00wXGjC+8OkL57FVwas0zGUiUY+hgLU1OkQ6kEk8=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage $releaseDir/build/*/out/dysk.1
    installShellCompletion $releaseDir/build/*/out/{dysk.bash,dysk.fish,_dysk}
  '';

  meta = {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/dysk";
    changelog = "https://github.com/Canop/dysk/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      koral
      osbm
    ];
    mainProgram = "dysk";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
