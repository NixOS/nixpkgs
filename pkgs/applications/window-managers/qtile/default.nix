{ stdenv, fetchFromGitHub, buildPythonPackage, python27Packages, pkgs }:

buildPythonPackage rec {
  name = "qtile-${version}";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "qtile";
    repo = "qtile";
    rev = "v${version}";
    sha256 = "1g02lvk2cqy6w6y6nw6dnsmy4i9k4fyawyibpkf0a7a1nfrd6a99";
  };

  patches = [ ./restart_executable.patch ];

  postPatch = ''
    substituteInPlace libqtile/manager.py --subst-var-by out $out
  '';

  buildInputs = [ pkgs.pkgconfig pkgs.glib pkgs.xorg.libxcb pkgs.cairo pkgs.pango python27Packages.xcffib ];

  cairocffi-xcffib = python27Packages.cairocffi.override {
    LD_LIBRARY_PATH = "${pkgs.xorg.libxcb}/lib:${pkgs.cairo}/lib";
    pythonPath = [ python27Packages.xcffib ];
  };

  pythonPath = with python27Packages; [ xcffib cairocffi-xcffib trollius readline ];

  LD_LIBRARY_PATH = "${pkgs.xorg.libxcb}/lib:${pkgs.cairo}/lib";

  postInstall = ''
    wrapProgram $out/bin/qtile \
      --prefix LD_LIBRARY_PATH : ${pkgs.xorg.libxcb}/lib \
      --prefix LD_LIBRARY_PATH : ${pkgs.glib}/lib \
      --prefix LD_LIBRARY_PATH : ${pkgs.cairo}/lib \
      --prefix LD_LIBRARY_PATH : ${pkgs.pango}/lib
  '';

  meta = with stdenv.lib; {
    homepage = http://www.qtile.org/;
    license = licenses.mit;
    description = "A small, flexible, scriptable tiling window manager written in Python";
    platforms = platforms.linux;
    maintainers = with maintainers; [ kamilchm ];
  };
}

