{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  withQt ? true,
  qtbase,
  wrapQtAppsHook,
  withCurses ? false,
  ncurses,
}:
stdenv.mkDerivation rec {
  version = "12.4";
  pname = "textadept";

  src = fetchFromGitHub {
    name = "textadept11";
    owner = "orbitalquark";
    repo = "textadept";
    rev = "textadept_${version}";
    sha256 = "sha256-nPgpQeBq5Stv2o0Ke4W2Ltnx6qLe5TIC5a8HSYVkmfI=";
  };

  nativeBuildInputs = [ cmake ] ++ lib.optionals withQt [ wrapQtAppsHook ];

  buildInputs = lib.optionals withQt [ qtbase ] ++ lib.optionals withCurses ncurses;

  cmakeFlags =
    lib.optional withQt [ "-DQT=ON" ]
    ++ lib.optional withCurses [
      "-DCURSES=ON"
      "-DQT=OFF"
    ];

  preConfigure =
    ''
      mkdir -p $PWD/build/_deps

    ''
    + lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: params: "ln -s ${fetchurl params} $PWD/build/_deps/${name}"
      ) (import ./deps.nix)
    );

  meta = with lib; {
    description = "Extensible text editor based on Scintilla with Lua scripting";
    homepage = "http://foicica.com/textadept";
    license = licenses.mit;
    maintainers = with maintainers; [
      raskin
      mirrexagon
      arcuru
    ];
    platforms = platforms.linux;
    mainProgram = "textadept";
  };
}
