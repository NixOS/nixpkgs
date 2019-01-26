{ stdenv, fetchFromGitHub, python37Packages, glib, cairo, pango, pkgconfig, libxcb, xcbutilcursor }:

let cairocffi-xcffib = python37Packages.cairocffi.override {
    withXcffib = true;
  };
in

python37Packages.buildPythonApplication rec {
  name = "qtile-${version}";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "qtile";
    repo = "qtile";
    rev = "v${version}";
    sha256 = "1lyclnn8hs6wl4w9v5b4hh2q0pvmsn7cyibpskhbpw0cgv7bvi90";
  };

  patches = [
    ./0001-Substitution-vars-for-absolute-paths.patch
    ./0002-Restore-PATH-and-PYTHONPATH.patch
    ./0003-Restart-executable.patch
  ];

  postPatch = ''
    substituteInPlace libqtile/manager.py --subst-var-by out $out
    substituteInPlace libqtile/pangocffi.py --subst-var-by glib ${glib.out}
    substituteInPlace libqtile/pangocffi.py --subst-var-by pango ${pango.out}
    substituteInPlace libqtile/xcursors.py --subst-var-by xcb-cursor ${xcbutilcursor.out}
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libxcb cairo pango python37Packages.xcffib ];

  pythonPath = with python37Packages; [ xcffib cairocffi-xcffib ];

  postInstall = ''
    wrapProgram $out/bin/qtile \
      --run 'export QTILE_WRAPPER=$0' \
      --run 'export QTILE_SAVED_PYTHONPATH=$PYTHONPATH' \
      --run 'export QTILE_SAVED_PATH=$PATH'
  '';

  doCheck = false; # Requires X server.

  meta = with stdenv.lib; {
    homepage = http://www.qtile.org/;
    license = licenses.mit;
    description = "A small, flexible, scriptable tiling window manager written in Python";
    platforms = platforms.linux;
    maintainers = with maintainers; [ kamilchm ];
  };
}
