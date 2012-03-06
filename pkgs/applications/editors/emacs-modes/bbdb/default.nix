{stdenv, fetchurl, emacs, texinfo, ctags}:

stdenv.mkDerivation {
  name = "bbdb-2.35";

  src = fetchurl {
    url = http://bbdb.sourceforge.net/bbdb-2.35.tar.gz;
    sha256 = "3fb1316e2ed74d47ca61187fada550e58797467bd9e8ad67343ed16da769f916";
  };

  patches = [ ./install-infodir.patch ];

  buildInputs = [emacs texinfo ctags];
  configureFlags = "--with-package-dir=$$out/share/emacs/site-lisp";
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
    description = "The Insidious Big Brother Database (BBDB), a contact management utility for Emacs";
    homepage = http://bbdb.sourceforge.net/;
    license = "GPL";
  };
}
