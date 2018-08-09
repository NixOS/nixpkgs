{stdenv, fetchurl, emacs, texinfo, ctags}:

stdenv.mkDerivation rec {
  name = "bbdb-2.36";

  src = fetchurl {
    # not using mirror:// because it produces a different file
    url = "http://bbdb.sourceforge.net/${name}.tar.gz";
    sha256 = "1rmw94l71ahfbynyy0bijfy488q9bl5ksl4zpvg7j9dbmgbh296r";
  };

  patches = [ ./install-infodir.patch ];

  buildInputs = [emacs texinfo ctags];
  configureFlags = [ "--with-package-dir=$$out/share/emacs/site-lisp" ];
  preInstall = "mkdir -p $out/info";
  installTargets = "install-pkg texinfo";
  postInstall = ''
    mv  $out/info $out/share/
    mv "$out/share/emacs/site-lisp/lisp/bbdb/"* $out/share/emacs/site-lisp/
    mv $out/share/emacs/site-lisp/etc/bbdb $out/share/
    rm -rf $out/share/emacs/site-lisp/{lisp,etc}
    mv bits $out/share/bbdb/
    # Make optional modules from bbdb available for import, but symlink
    # them into the site-lisp directory to make it obvious that they are
    # not a genuine part of the distribution.
    ln -s "$out/share/bbdb/bits/"*.el $out/share/emacs/site-lisp/
  '';

  meta = {
    homepage = http://bbdb.sourceforge.net/;
    description = "The Insidious Big Brother Database (BBDB), a contact management utility for Emacs";
    license = "GPL";
  };
}
