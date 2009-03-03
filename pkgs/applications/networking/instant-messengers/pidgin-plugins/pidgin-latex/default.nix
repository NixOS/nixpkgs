{ stdenv, fetchurl, pidgin, imagemagick, ghostscript
, pkgconfig, glib, gtk, texLive
}:
        
stdenv.mkDerivation {
  name = "pidgin-latex";

  src = fetchurl {
    url = http://tapas.affenbande.org/pidgin-latex/pidgin-latex-0.9.tgz;
    sha256 = "1yqd3qgxd3n8hm60qg7yv7j1crr6f3d4yrdpgwdpw2pyf92p8nxp";
  };

  preBuild = ''
    sed -e '/^PREFIX/d' -i Makefile ; 
    sed -e 's@/usr/bin/latex@${texLive}/bin/pdflatex@g' -i pidgin-latex.h
    sed -e 's@/usr/bin/convert@${imagemagick}/bin/convert@g' -i pidgin-latex.h
    sed -e 's@.*convert_path.*@const gchar *convert = CONVERT_PATH;@'
    sed -e 's@.*latex_path.*@const gchar *convert = LATEX_PATH;@'
    sed -e 's/%s.dvi/%s.pdf/' -i pidgin-latex.c
    sed -e 's/latex_system\(.*\)FALSE/latex_system\1TRUE/' -i pidgin-latex.c
  '';

  makeFlags = "PREFIX=\$(out)";

  preInstall = "mkdir -p $out/lib/pidgin $out/bin";
  
  postInstall = ''
    mkdir -p $out/share/pidgin-latex
    ln -s $out/lib/pidgin/pidgin-latex.so $out/share/pidgin-latex/
  '';

  buildInputs = [pidgin imagemagick ghostscript pkgconfig glib gtk texLive];

  meta = {
    longDescription = ''
      Pidgin-LaTeX is a pidgin plugin that cuts everything inside \$\$
      .. \$\$ and feeds to LaTeX. A bit of conversion (automated, of
      course) - and you see every formula that occurs in conversation
      in pretty graphical form.  There are some glitches - when a
      formula fails to compile, you can see just previous formula..
      Enable it for user by linking to ~/.purple/plugins - from
      sw/share/pidgin-latex , not from store of course.
    '';
    homepage = http://tapas.affenbande.org/wordpress/?page_id=70;
  };
}
