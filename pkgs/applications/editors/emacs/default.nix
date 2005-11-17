{ xawSupport ? true
, xpmSupport ? true
, xaw3dSupport ? false
, stdenv, fetchurl, x11, libXaw ? null, libXpm ? null, Xaw3d ? null
}:

assert xawSupport -> libXaw != null;
assert xpmSupport -> libXpm != null;
assert xaw3dSupport -> Xaw3d != null;

stdenv.mkDerivation {
  name = "emacs-21.4a";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://ftp.gnu.org/pub/gnu/emacs/emacs-21.4a.tar.gz;
    md5 = "8f9d97cbd126121bd5d97e5e31168a87";
  };
  patches = [./crt.patch];
  buildInputs = [
    x11
    (if xawSupport then libXaw else null)
    (if xpmSupport then libXpm else null)
    (if xaw3dSupport then Xaw3d else null)
  ];
}
