{ lib, stdenv, fetchurl, pkg-config, gtk2, synergy }:

stdenv.mkDerivation rec {
  pname = "quicksynergy";
  version = "0.9.0";
  src = fetchurl {
    url =
      "mirror://sourceforge/project/quicksynergy/Linux/${version}/quicksynergy-${version}.tar.gz";
    sha256 = "1pi8503bg8q1psw50y6d780i33nnvfjqiy9vnr3v52pdcfip8pix";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 synergy ];
  preBuild =
    "\n    sed -i 's@/usr/bin@${synergy.out}/bin@' src/synergy_config.c\n  ";
  meta = {
    description =
      "GUI application to share mouse and keyboard between computers";
    longDescription =
      "\n      QuickSynergy is a graphical interface (GUI) for easily configuring\n      Synergy2, an application that allows the user to share his mouse and\n      keyboard between two or more computers.\n\n      Without the need for any external hardware, Synergy2 uses the TCP-IP\n      protocol to share the resources, even between machines with diferent\n      operating systems, such as Mac OS, Linux and Windows.\n\n      Remember to open port 24800 (used by synergys program) if you want to\n      host mouse and keyboard.";
    homepage = "https://sourceforge.net/projects/quicksynergy/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.spinus ];
    platforms = lib.platforms.linux;
  };
}
