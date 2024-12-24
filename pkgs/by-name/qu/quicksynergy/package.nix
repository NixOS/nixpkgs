{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gtk2,
  synergy,
}:

stdenv.mkDerivation rec {
  pname = "quicksynergy";
  version = "0.9.0";
  src = fetchurl {
    url = "mirror://sourceforge/project/quicksynergy/Linux/${version}/quicksynergy-${version}.tar.gz";
    sha256 = "1pi8503bg8q1psw50y6d780i33nnvfjqiy9vnr3v52pdcfip8pix";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    gtk2
    synergy
  ];
  preBuild = "
    sed -i 's@/usr/bin@${synergy.out}/bin@' src/synergy_config.c
  ";
  meta = {
    description = "GUI application to share mouse and keyboard between computers";
    longDescription = "
      QuickSynergy is a graphical interface (GUI) for easily configuring
      Synergy2, an application that allows the user to share his mouse and
      keyboard between two or more computers.

      Without the need for any external hardware, Synergy2 uses the TCP-IP
      protocol to share the resources, even between machines with different
      operating systems, such as Mac OS, Linux and Windows.

      Remember to open port 24800 (used by synergys program) if you want to
      host mouse and keyboard.";
    homepage = "https://sourceforge.net/projects/quicksynergy/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.spinus ];
    platforms = lib.platforms.linux;
    mainProgram = "quicksynergy";
  };
}
