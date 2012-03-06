args : with args; 
rec {
  src = fetchurl {
    url = http://mesh.dl.sourceforge.net/sourceforge/pidgin-latex/pidgin-latex-1.2.1.tar.bz2;
    sha256 = "19h76fwsx5y30l5wda2930k10r385aipngfljz5bdi7b9y52lii7";
  };

  buildInputs = [texLive pkgconfig gtk imagemagick glib pidgin which];
  configureFlags = [];
  installFlags = [
    "PREFIX=$out"
  ];

  preBuild = fullDepEntry (''
    mkdir -p $out/bin
    ln -s $(which convert) $out/bin
    ln -s $(which xelatex) $out/bin
    ln -s $(which dvips) $out/bin

    sed -e 's/-Wl,-soname//' -i Makefile
    sed -e 's/\(PATH("\)latex/\1xelatex/' -i LaTeX.c
    sed -e 's/|| execute(cmddvips, dvipsopts, 10) //' -i LaTeX.c
    sed -e 's/  strcat([*]file_ps, "[.]ps");/  strcat(*file_ps, ".pdf");/' -i LaTeX.c
    sed -e 's/\([*]convertopts\[5\]=[{]"\)\(\\"",\)/\1 -trim \2/' -i LaTeX.c
    sed -e 's/\(#define HEADER ".*\)12pt\(.*\)"/\116pt\2\\\\usepackage{fontspec}\\\\usepackage{xunicode}"/' -i LaTeX.h
  '') ["minInit" "addInputs" "defEnsureDir" "doUnpack"];

  postInstall = fullDepEntry (''
    mkdir -p $out/lib
    mkdir -p $out/share/pidgin-latex
    ln -s ../../lib/pidgin/LaTeX.so  $out/share/pidgin-latex 
  '') ["minInit" "defEnsureDir" "doMakeInstall"];

  /* doConfigure should be specified separately */
  phaseNames = [ "preBuild" "doMakeInstall" "postInstall"];
      
  name = "pidgin-latex-1.2.1";
  meta = {
    description = "LaTeX rendering plugin for Pidgin IM";
    priority = "10";
  };
}
