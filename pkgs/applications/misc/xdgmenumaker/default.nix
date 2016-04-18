{ stdenv, fetchFromGitHub, txt2tags, python2Packages }:

stdenv.mkDerivation rec {
  name = "xdgmenumaker-${version}";
  version = "0.9";

  src = fetchFromGitHub {
    rev = version;
    owner = "gapan";
    repo = "xdgmenumaker";
    sha256 = "1n29syadsgj0vpnkc8nji4k1c8gminr1xdriz5ck2bcygsgxkdrd";
  };

  nativeBuildInputs = [
    txt2tags
    python2Packages.wrapPython
  ];

  pythonPath = [
    python2Packages.pyxdg
    python2Packages.pygtk
  ];

  installPhase = ''
    make install PREFIX=$out DESTDIR=
    wrapProgram "$out/bin/xdgmenumaker" \
      --prefix XDG_DATA_DIRS : "$out/share"
    wrapPythonPrograms
  '';
  
  meta = with stdenv.lib; {
    description = "Command line tool that generates XDG menus for several window managers";
    homepage = https://github.com/gapan/xdgmenumaker;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
