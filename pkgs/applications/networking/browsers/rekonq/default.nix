{ stdenv, fetchurl, fetchgit, cmake, qt4, kdelibs, automoc4, phonon, perl
, v ? "0.4.0" }:

stdenv.mkDerivation (
  builtins.getAttr v (import ./source.nix { inherit fetchurl fetchgit; })
  // {
    buildInputs = [ cmake qt4 kdelibs automoc4 phonon perl ];

    meta = with stdenv.lib; {
      platforms = platforms.linux;
      maintainers = [ maintainers.urkud ];
      description = "KDE Webkit browser";
      homepage = http://rekonq.sourceforge.net;
    };
  }
)
