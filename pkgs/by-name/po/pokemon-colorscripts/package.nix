{
  stdenv,
  fetchFromGitLab,
  lib,
  ...
}:

stdenv.mkDerivation {
  pname = "pokemon-colorscripts";
  version = "0-unstable-2024-10-19";

  src = fetchFromGitLab {
    owner = "phoneybadger";
    repo = "pokemon-colorscripts";
    rev = "5802ff67520be2ff6117a0abc78a08501f6252ad";
    hash = "sha256-gKVmpHKt7S2XhSxLDzbIHTjJMoiIk69Fch202FZffqU=";
  };

  postPatch = ''
    patchShebangs ./install.sh
    substituteInPlace install.sh --replace-fail "/usr/local" "$out"
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    ./install.sh

    runHook postInstall
  '';

  meta = with lib; {
    description = "Scripts for Pokémon color manipulation";
    homepage = "https://gitlab.com/phoneybadger/pokemon-colorscripts";
    license = licenses.mit;
    maintainers = [ lib.maintainers.viitorags ];
  };
}
