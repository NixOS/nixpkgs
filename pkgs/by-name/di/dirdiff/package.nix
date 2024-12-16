{
  copyDesktopItems,
  fetchurl,
  lib,
  makeDesktopItem,
  stdenv,
  tcl,
  tk,
}:

stdenv.mkDerivation rec {
  pname = "dirdiff";
  version = "2.1";

  src = fetchurl {
    url = "mirror://samba/paulus/${pname}-${version}.tar.gz";
    sha256 = "0lljd8av68j70733yshzzhxjr1lm0vgmbqsm8f02g03qsma3cdyb";
  };

  nativeBuildInputs = [ copyDesktopItems ];
  buildInputs = [
    tcl
    tk
  ];

  # Some light path patching.
  patches = [ ./dirdiff-2.1-vars.patch ];
  postPatch = ''
    for file in dirdiff Makefile; do
      substituteInPlace "$file" \
          --subst-var out \
          --subst-var-by tcl ${tcl} \
          --subst-var-by tk ${tk}
    done
  '';

  env = {
    NIX_CFLAGS_COMPILE = "-DUSE_INTERP_RESULT";
    NIX_LDFLAGS = "-ltcl";
  };

  # If we don't create the directories ourselves, then 'make install' creates
  # files named 'bin' and 'lib'.
  preInstall = ''
    mkdir -p $out/bin $out/lib
  '';

  installFlags = [
    "BINDIR=${placeholder "out"}/bin"
    "LIBDIR=${placeholder "out"}/lib"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "dirdiff";
      exec = "dirdiff";
      desktopName = "Dirdiff";
      genericName = "Directory Diff Viewer";
      comment = "Diff and merge directory trees";
      categories = [ "Development" ];
    })
  ];

  meta = with lib; {
    description = "Graphical directory tree diff and merge tool";
    mainProgram = "dirdiff";
    longDescription = ''
      Dirdiff is a graphical tool for displaying the differences between
      directory trees and for merging changes from one tree into another.
    '';
    homepage = "https://www.samba.org/ftp/paulus/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ khumba ];
    platforms = platforms.unix;
  };
}
