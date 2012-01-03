{ xawSupport ? true
, xpmSupport ? true
, dbusSupport ? true
, xaw3dSupport ? false
, gtkGUI ? false
, xftSupport ? false
, stdenv, fetchcvs, ncurses, x11, libXaw ? null, libXpm ? null, Xaw3d ? null
, pkgconfig ? null, gtk ? null, libXft ? null, dbus ? null
, libpng, libjpeg, libungif, libtiff, texinfo
, autoconf, automake
}:

assert xawSupport -> libXaw != null;
assert xpmSupport -> libXpm != null;
assert dbusSupport -> dbus != null;
assert xaw3dSupport -> Xaw3d != null;
assert gtkGUI -> pkgconfig != null && gtk != null;
assert xftSupport -> libXft != null && libpng != null; # libpng = probably a bug

let date = "2009-06-26"; in
stdenv.mkDerivation {
  name = "emacs-snapshot-23-${date}";
  
  builder = ./builder.sh;
  
  src = fetchcvs {
    inherit date;
    cvsRoot = ":pserver:anonymous@cvs.savannah.gnu.org:/sources/emacs";
    module = "emacs";
    sha256 = "bf9b21a0634f45474a1ce91e6153ced69194f1e9c0acd6626a931198f4a5972f";
  };

  preConfigure = "autoreconf -vfi";
  
  buildInputs = [
    autoconf automake
    ncurses x11 texinfo
    (if xawSupport then libXaw else null)
    (if xpmSupport then libXpm else null)
    (if dbusSupport then dbus else null)
    (if xaw3dSupport then Xaw3d else null)
    libpng libjpeg libungif libtiff # maybe not strictly required?
  ]
  ++ (if gtkGUI then [pkgconfig gtk] else [])
  ++ (if xftSupport then [libXft] else []);
  
  configureFlags = "
    ${if gtkGUI then "--with-x-toolkit=gtk --enable-font-backend --with-xft" else ""}
  ";

  postInstall = ''
    cat >$out/share/emacs/site-lisp/site-start.el <<EOF
;; nixos specific load-path
(setq load-path
      (append (reverse (mapcar (lambda (x) (concat x "/share/emacs/site-lisp/"))
                               (split-string (getenv "NIX_PROFILES"))))
              load-path))
EOF
  '';

  meta = {
    description = "GNU Emacs with Unicode, GTK and Xft support (23.x alpha)";
    homepage = http://www.emacswiki.org/cgi-bin/wiki/XftGnuEmacs;
    license = "GPLv3+";
    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.linux;  # GTK & co. are needed.
  };
}
