{
  stdenv,
  fetchFromGitLab,
  # patchShebangs,
  lib,
  ...
}:

stdenv.mkDerivation {
  pname = "pokemon-colorscripts";
  version = "2024-10-19-8fab453";

  src = fetchFromGitLab {
    owner = "phoneybadger";
    repo = "pokemon-colorscripts";
    rev = "8fab453f15eeb20cbae61e297698e2a892a690b9";
    sha256 = "19bybxbdid0xf92sz4w8i0rcjf0xr0v0yjrchnbjvvddfaj6d9c0";
  };

  # nativeBuildInputs = [ patchShebangs ];

  postPatch = ''
    patchShebangs ./install.sh
    substituteInPlace install.sh --replace /usr/local $out
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
    maintainers = with maintainers; [ viitorags ];
  };
}
