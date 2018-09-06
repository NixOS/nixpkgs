{ stdenv, fetchFromGitHub, python27Packages, glib, cairo, pango, pkgconfig, libxcb, xcbutilcursor }:

let cairocffi-xcffib = python27Packages.cairocffi.override {
    withXcffib = true;
  };
in

python27Packages.buildPythonApplication rec {
  name = "qtile-${version}";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "qtile";
    repo = "qtile";
    rev = "v${version}";
    sha256 = "0ynmmnh12mr3gwgz0j7l2hvm8c0y5gzsw80jszdkp4s5bh1q0nrj";
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
  buildInputs = [ glib libxcb cairo pango python27Packages.xcffib ];

  pythonPath = with python27Packages; [ xcffib cairocffi-xcffib trollius ];

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
