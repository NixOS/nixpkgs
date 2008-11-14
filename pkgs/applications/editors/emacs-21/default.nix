{ xawSupport ? true
, xpmSupport ? true
, xaw3dSupport ? false
, stdenv, fetchurl, ncurses, x11, libXaw ? null, libXpm ? null, Xaw3d ? null
}:

assert xawSupport && !xaw3dSupport -> libXaw != null;
assert xawSupport && xaw3dSupport -> Xaw3d != null;
assert xpmSupport -> libXpm != null;

stdenv.mkDerivation {
  name = "emacs-21.4a";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nixos.org/tarballs/emacs-21.4a.tar.gz;
    md5 = "8f9d97cbd126121bd5d97e5e31168a87";
  };
  patches = [./crt.patch];
  buildInputs = [
    ncurses x11
    (if xawSupport then if xaw3dSupport then Xaw3d else libXaw else null)
    (if xpmSupport then libXpm else null)
  ];

  meta = {
    description = "All Hail Emacs, the ultimate editor";
  };
}
