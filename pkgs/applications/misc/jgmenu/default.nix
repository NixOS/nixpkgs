{ stdenv, fetchFromGitHub, pkgconfig, python3Packages, pango, librsvg, libxml2, menu-cache, xorg, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "jgmenu";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "johanmalm";
    repo = pname;
    rev = "v${version}";
    sha256 = "086p91l1igx5mv2i6fwbgx5p72war9aavc7v3m7sd0c0xvb334br";
  };

  nativeBuildInputs = [
    pkgconfig
    makeWrapper
    python3Packages.wrapPython
  ];

  buildInputs = [
    pango
    librsvg
    libxml2
    menu-cache
    xorg.libXinerama
    xorg.libXrandr
    python3Packages.python
  ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postFixup = ''
    wrapPythonProgramsIn "$out/lib/jgmenu"
    for f in $out/bin/jgmenu{,_run}; do
      wrapProgram $f --prefix PATH : $out/bin
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/johanmalm/jgmenu;
    description = "Small X11 menu intended to be used with openbox and tint2";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
