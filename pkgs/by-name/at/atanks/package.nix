{
  lib,
  stdenv,
  fetchurl,
  allegro,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atanks";
  version = "6.6";

  src = fetchurl {
    url = "mirror://sourceforge/project/atanks/atanks/atanks-${finalAttrs.version}/atanks-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-vGse/J/H52JPrR2DUtcuknvg+6IWC7Jbtri9bGNwv0M=";
  };

  buildInputs = [ allegro ];

  makeFlags = [
    "PREFIX=$(out)/"
    "INSTALL=install"
    "CXX=g++"
  ];

  meta = {
    description = "Atomic Tanks ballistics game";
    mainProgram = "atanks";
    homepage = "http://atanks.sourceforge.net/";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
})
