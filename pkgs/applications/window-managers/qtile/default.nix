{ stdenv, fetchFromGitHub, buildPythonApplication, python27Packages, pkgs }:

let cairocffi-xcffib = python27Packages.cairocffi.override {
    pythonPath = [ python27Packages.xcffib ];
  };
in

buildPythonApplication rec {
  name = "qtile-${version}";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "qtile";
    repo = "qtile";
    rev = "v${version}";
    sha256 = "0rwklzgkp3x242xql6qmfpfnhr788hd3jc1l80pc5ybxlwyfx59i";
  };

  patches = [
    ./0001-Substitution-vars-for-absolute-paths.patch
    ./0002-Restore-PATH-and-PYTHONPATH.patch
    ./0003-Restart-executable.patch
  ];

  postPatch = ''
    substituteInPlace libqtile/manager.py --subst-var-by out $out
    substituteInPlace libqtile/pangocffi.py --subst-var-by glib ${pkgs.glib.out}
    substituteInPlace libqtile/pangocffi.py --subst-var-by pango ${pkgs.pango.out}
    substituteInPlace libqtile/xcursors.py --subst-var-by xcb-cursor ${pkgs.xorg.xcbutilcursor.out}
  '';

  buildInputs = [ pkgs.pkgconfig pkgs.glib pkgs.xorg.libxcb pkgs.cairo pkgs.pango python27Packages.xcffib ];

  pythonPath = with python27Packages; [ xcffib cairocffi-xcffib trollius readline];

  postInstall = ''
    wrapProgram $out/bin/qtile \
      --set QTILE_WRAPPER '$0' \
      --set QTILE_SAVED_PYTHONPATH '$PYTHONPATH' \
      --set QTILE_SAVED_PATH '$PATH'
  '';

  meta = with stdenv.lib; {
    homepage = http://www.qtile.org/;
    license = licenses.mit;
    description = "A small, flexible, scriptable tiling window manager written in Python";
    platforms = platforms.linux;
    maintainers = with maintainers; [ kamilchm ];
  };
}

