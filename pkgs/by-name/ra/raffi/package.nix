{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeBinaryWrapper,
  fuzzel,
  additionalPrograms ? [ ],
}:

rustPlatform.buildRustPackage rec {
  pname = "raffi";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "raffi";
    rev = "v${version}";
    hash = "sha256-97gZZp2taX800Izhya4mYzS4PtCNCBbRnrn6cm1w8zY=";
  };

  cargoHash = "sha256-1n0JQdeExszuGFbpkBRT44eMov/x3BrIeofObdPNNdU=";

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  postFixup = ''
    wrapProgram $out/bin/raffi \
      --prefix PATH : ${lib.makeBinPath ([ fuzzel ] ++ additionalPrograms)}
  '';

  meta = {
    description = "Fuzzel launcher based on yaml configuration";
    homepage = "https://github.com/chmouel/raffi";
    changelog = "https://github.com/chmouel/raffi/releases/tag/v${version}";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ aos ];
    mainProgram = "raffi";
    platforms = lib.platforms.linux;
  };
}
