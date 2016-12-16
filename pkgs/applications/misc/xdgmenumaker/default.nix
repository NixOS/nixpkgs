{ stdenv, fetchFromGitHub, txt2tags, python2Packages }:

stdenv.mkDerivation rec {
  name = "xdgmenumaker-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "gapan";
    repo = "xdgmenumaker";
    rev = version;
    sha256 = "11mqafpgfnz0h0d6fxd1xsfsjxzg1abvwqgwy9jmm5xhcjx3c3l7";
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
    # NOTE: exclude darwin from platforms because Travis reports hash mismatch
    platforms = with platforms; filter (x: !(elem x darwin)) unix;
    maintainers = [ maintainers.romildo ];
  };
}
