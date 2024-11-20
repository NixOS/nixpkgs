{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
}:

let
  # These files can be found in Stockfish/src/evaluate.h
  nnueBigFile = "nn-31337bea577c.nnue";
  nnueBig = fetchurl {
    url = "https://tests.stockfishchess.org/api/nn/${nnueBigFile}";
    sha256 = "sha256-MTN76ld8W00LPlQYGGGJ7k9Yuq6rjX9vO9BXisp/d9k=";
  };
  nnueSmallFile = "nn-37f18f62d772.nnue";
  nnueSmall = fetchurl {
    url = "https://tests.stockfishchess.org/api/nn/${nnueSmallFile}";
    sha256 = "sha256-N/GPYtdy8xB+HWqso4mMEww8hvKrY+ZVX7vKIGNaiZ0=";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "fishnet";
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "lichess-org";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HlCnUJBhIhooBvQVz1SDfiifXIBkBlH2dEq+C9al7qI=";
    fetchSubmodules = true;
  };

  postPatch = ''
    cp -v '${nnueBig}' 'Stockfish/src/${nnueBigFile}'
    cp -v '${nnueBig}' 'Fairy-Stockfish/src/${nnueBigFile}'
    cp -v '${nnueSmall}' 'Stockfish/src/${nnueSmallFile}'
    cp -v '${nnueSmall}' 'Fairy-Stockfish/src/${nnueSmallFile}'
  '';

  cargoHash = "sha256-Fb28XNhCt88PFnJ4s0I80L/rLJtBTEZ8Xd/68MYFoLs=";

  meta = with lib; {
    description = "Distributed Stockfish analysis for lichess.org";
    homepage = "https://github.com/lichess-org/fishnet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      tu-maurice
      thibaultd
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "fishnet";
  };
}
