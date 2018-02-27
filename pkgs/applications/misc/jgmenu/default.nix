{ stdenv, fetchFromGitHub, pkgconfig, python3Packages, pango, librsvg, libxml2, menu-cache, xorg }:

stdenv.mkDerivation rec {
  name = "jgmenu-${version}";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "johanmalm";
    repo = "jgmenu";
    rev = "v${version}";
    sha256 = "0nflj4fcpz7rcd1s0zlyi5ikxjykkmz3p5w4gzica1fdbyn2l7x3";
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
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
