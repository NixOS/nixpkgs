{ stdenv, fetchFromGitHub, pkgconfig, python3Packages, pango, librsvg, libxml2, menu-cache, xorg }:

stdenv.mkDerivation rec {
  name = "jgmenu-${version}";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "johanmalm";
    repo = "jgmenu";
    rev = "v${version}";
    sha256 = "0hnxzy5mm5z6r9gaimfsf7kbpr23khck2fhh3j8bk2lkp53420fz";
  };

  nativeBuildInputs = [
    pkgconfig
    python3Packages.wrapPython
  ];

  buildInputs = [
    pango
    librsvg
    libxml2
    menu-cache
    xorg.libXinerama
  ];

  makeFlags = [ "prefix=$(out)" ];

  postFixup = ''
    wrapPythonProgramsIn "$out/lib/jgmenu"
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/johanmalm/jgmenu;
    description = "Small X11 menu intended to be used with openbox and tint2";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
