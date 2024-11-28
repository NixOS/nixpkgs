{ lib
, fetchFromGitHub
, rustPlatform
, makeBinaryWrapper
, fuzzel
, additionalPrograms ? [ ]
}:

rustPlatform.buildRustPackage rec {
  pname = "raffi";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "raffi";
    rev = "v${version}";
    hash = "sha256-25dH6LprqcZq9Px5nFNrGHk/2Tn23TZMLVZVic0unU8=";
  };

  cargoHash = "sha256-bkNjlX8WH8+q4I+VfYZeraf2vyHtDFZQCbXzsdehCZQ=";

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
