{
  stdenv,
  fetchFromGitLab,
  # patchShebangs,
  lib,
  ...
}:

stdenv.mkDerivation {
  pname = "pokemon-colorscripts";
  version = "0-unstable-2024-10-19";

  src = fetchFromGitLab {
    owner = "phoneybadger";
    repo = "pokemon-colorscripts";
    rev = "8fab453f15eeb20cbae61e297698e2a892a690b9";
    hash = "sha256-gKVmpHKt7S2XhSxLDzbIHTjJMoiIk69Fch202FZffqU=";
  };

  # nativeBuildInputs = [ patchShebangs ];

  postPatch = ''
    patchShebangs ./install.sh
    substituteInPlace install.sh --replace-fail "/usr/local" "$out"
  '';

  installPhase = ''
    mkdir -p $out/opt
    mkdir -p $out/bin
    ./install.sh
  '';

  meta = with lib; {
    description = "Scripts for Pokémon color manipulation";
    homepage = "https://gitlab.com/phoneybadger/pokemon-colorscripts";
    license = licenses.mit;
    maintainers = [ lib.maintainers.viitorags ];
  };
}
