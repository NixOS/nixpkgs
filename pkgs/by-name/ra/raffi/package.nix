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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "raffi";
    rev = "v${version}";
    hash = "sha256-VwB5hYEGF+w7KUBVB306VCneJxRwlZG5KVdrmhYqlYk=";
  };

  cargoHash = "sha256-AQhGutsMhVjKi2kenvKatN91B7Oi9n64+RDj/ODwfno=";

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
