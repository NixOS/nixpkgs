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

  preBuild = FullDepEntry (''
    ensureDir $out/lib
    ensureDir $out/bin
    ensureDir $out/share/pidgin/pidgin-latex
    ln -s $(which convert) $out/bin
    ln -s $(which latex) $out/bin
    ln -s $(which dvips) $out/bin
    ln -s ../../../lib/LaTeX.so  $out/share/pidgin/pidgin-latex 
  '') ["minInit" "addInputs" "defEnsureDir"];

  /* doConfigure should be specified separately */
  phaseNames = [ "preBuild" "doMakeInstall"];
      
  name = "pidgin-latex-1.2.1";
  meta = {
    description = "LaTeX rendering plugin for Pidgin IM";
    priority = "10";
  };
}
