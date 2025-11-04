{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage rec {
  pname = "dysk";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "dysk";
    rev = "v${version}";
    hash = "sha256-trqHMlBA2s5l0ay3/e6hzMZTtKndrHRTy1LhuLwrJb4=";
  };

  cargoHash = "sha256-uloX/Mk4m7jEU5z5cb/gSuCLEGhG9qHTCQwjy+FCUsk=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installManPage $releaseDir/build/*/out/dysk.1
    installShellCompletion $releaseDir/build/*/out/{dysk.bash,dysk.fish,_dysk}
  '';

  meta = with lib; {
    description = "Get information on your mounted disks";
    homepage = "https://github.com/Canop/dysk";
    changelog = "https://github.com/Canop/dysk/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      koral
    ];
    mainProgram = "dysk";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
