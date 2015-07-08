{ stdenv, fetchFromGitHub, buildPythonPackage, python27Packages, pkgs }:

buildPythonPackage rec {
  name = "qtile-${version}";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "qtile";
    repo = "qtile";
    rev = "v${version}";
    sha256 = "1lwqxvld54lgqj8jx2vkd7f5qd7cxmyz5xnn8jp8ly0xmpvmhhb7";
  };

  buildInputs = [ pkgs.pkgconfig pkgs.glib pkgs.xlibs.libxcb pkgs.cairo pkgs.pango python27Packages.xcffib ];

  cairocffi-xcffib = python27Packages.cairocffi.override {
    LD_LIBRARY_PATH = "${pkgs.xlibs.libxcb}/lib:${pkgs.cairo}/lib";
    pythonPath = [ python27Packages.xcffib ];
  };

  pythonPath = with python27Packages; [ xcffib cairocffi-xcffib trollius readline ];

  LD_LIBRARY_PATH = "${pkgs.xlibs.libxcb}/lib:${pkgs.cairo}/lib";

  postInstall = ''
    wrapProgram $out/bin/qtile \
      --prefix LD_LIBRARY_PATH : ${pkgs.xlibs.libxcb}/lib \
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

