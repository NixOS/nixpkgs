{
  coreutils,
  fetchFromGitLab,
  lib,
  python3,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "pokemon-colorscripts";
  version = "0-unstable-2025-06-25";

  src = fetchFromGitLab {
    owner = "phoneybadger";
    repo = "pokemon-colorscripts";
    rev = "5802ff67520be2ff6117a0abc78a08501f6252ad";
    hash = "sha256-gKVmpHKt7S2XhSxLDzbIHTjJMoiIk69Fch202FZffqU=";
  };

  buildInputs = [
    coreutils
    python3
  ];

  preBuild = ''
    substituteInPlace install.sh --replace-fail /usr/local $out
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt
    mkdir -p $out/bin
    ./install.sh

    runHook postInstall
  '';

  meta = {
    description = "CLI utility to print out images of pokemon to terminal";
    homepage = "https://gitlab.com/phoneybadger/pokemon-colorscripts";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.codebam ];
    platforms = lib.platforms.unix;
  };
}
