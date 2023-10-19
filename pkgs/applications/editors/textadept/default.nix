{ lib, stdenv, fetchFromGitHub, fetchurl, cmake, qtbase, wrapQtAppsHook }:
stdenv.mkDerivation rec {
  version = "12.0";
  pname = "textadept";

  src = fetchFromGitHub {
    name = "textadept11";
    owner = "orbitalquark";
    repo = "textadept";
    rev = "textadept_${version}";
    sha256 = "sha256-KziVN0Fl/IvSnIJKK5s7UikXi3iP5mTauP0YxffKy9c=";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook ];
  buildInputs = [ qtbase ];

  cmakeFlags = [
    "CMAKE_INSTALL_PREFIX=build/install"
  ];

  preConfigure = ''
    mkdir -p $PWD/build/_deps

    '' +
    lib.concatStringsSep "\n" (lib.mapAttrsToList (name: params:
      "ln -s ${fetchurl params} $PWD/build/_deps/${name}"
    ) (import ./deps.nix));

  meta = with lib; {
    description = "An extensible text editor based on Scintilla with Lua scripting.";
    homepage = "http://foicica.com/textadept";
    license = licenses.mit;
    maintainers = with maintainers; [ raskin mirrexagon patricksjackson ];
    platforms = platforms.linux;
  };
}
