{ lib, stdenv, fetchFromGitHub, fetchurl, cmake, qtbase, wrapQtAppsHook }:
stdenv.mkDerivation rec {
  version = "11.4.14"; # TODO: THAT'S A DUMMY VERSION NUMBER; CHANGE TO 12.0 WHEN RELEASED.
  pname = "textadept";

  src = fetchFromGitHub {
    name = "textadept11";
    owner = "orbitalquark";
    repo = "textadept";
#    rev = "textadept_${version}";
    rev = "995b00999872f09d1364daf6951830cb166925ac"; # TODO: WHEN PACKAGE RELEASE, UNCOMMENT PREVIOUS LINE AND REMOVE THIS ONE.
    sha256 = "sha256-8u+FhfdMvKxgeESynb+/u1pr1bTTOfkKfFavVQMPzbo=";
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
