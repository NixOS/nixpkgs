{stdenv, fetchurl, pidgin, imagemagick, ghostscript,
	pkgconfig, glib, gtk, tetex}:
stdenv.mkDerivation {
  name = "pidgin-latex";

  src = fetchurl {
    url = http://tapas.affenbande.org/pidgin-latex.tgz;
    md5 = "12509b38f7a92bb22d565cc73cbd83c7";
  };

  preBuild = "sed -e '/^PREFIX/d' -i Makefile ; 
	sed -e 's@/bin/bash@/var/run/current-system/sw&@; s@/dev/stdin@/proc/self/fd/0@' -i pidgin-latex-convert.sh;
	sed -e 's@^latex.*@& ; if let \$?; then rm /tmp/pidgin-latex-tmp.png; exit 1; fi; @' -i pidgin-latex-convert.sh ; ";

  makeFlags="PREFIX=\$(out)";

  preInstall="mkdir -p \${out}/lib/pidgin \${out}/bin";
  
  postInstall = "mkdir -p \${out}/share/pidgin-latex; 
	ln -s \${out}/lib/pidgin/pidgin-latex.so \${out}/share/pidgin-latex/";

  buildInputs = [pidgin imagemagick ghostscript pkgconfig glib gtk tetex];

  meta = {
    description = "
	Pidgin-LaTeX is a pidgin plugin that cuts everything inside \$\$ .. \$\$
	and feeds to LaTeX. A bit of conversion (automated, of course) - and you
	see every formula that occurs in conversation in pretty graphical form.
	There are some glitches - when a formula fails to compile, you can see 
	just previous formula..
	Enable it for user by linking to ~/.purple/plugins - from 
	sw/share/pidgin-latex , not from store of course.
";
  };
}
