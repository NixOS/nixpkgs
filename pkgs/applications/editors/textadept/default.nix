{ lib, stdenv, fetchFromGitHub, fetchurl, cmake, qtbase, wrapQtAppsHook }:
stdenv.mkDerivation rec {
  version = "11.4.15"; # TODO: THAT'S A DUMMY VERSION NUMBER; CHANGE TO 12.0 WHEN RELEASED.
  pname = "textadept";

  src = fetchFromGitHub {
    name = "textadept11";
    owner = "orbitalquark";
    repo = "textadept";
#    rev = "textadept_${version}";
    rev = "19cfa3ce0c7d2f981d2b8cbbee4f8e603be9b5db"; # TODO: WHEN PACKAGE RELEASE, UNCOMMENT PREVIOUS LINE AND REMOVE THIS ONE.
    sha256 = "sha256-FkqoODP2nIOCBy2DqelAdGInizhADpc3ZdzbrRTnSdA=";
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
