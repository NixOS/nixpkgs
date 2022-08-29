{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, cairo
, fontconfig
, freetype
, fribidi
, libXcursor
, libXft
, libXinerama
, libXpm
, libXt
, libpng
, librsvg
, libstroke
, libxslt
, perl
, pkg-config
, python3Packages
, readline
, enableGestures ? false
}:

stdenv.mkDerivation rec {
  pname = "fvwm";
  version = "2.6.9";

  src = fetchFromGitHub {
    owner = "fvwmorg";
    repo = pname;
    rev = version;
    hash = "sha256-sBVOrrl2WrZ2wWN/r1kDUtR+tPwXgDoSJDaxGeFkXJI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3Packages.wrapPython
  ];

  buildInputs = [
    cairo
    fontconfig
    freetype
    fribidi
    libXcursor
    libXft
    libXinerama
    libXpm
    libXt
    libpng
    librsvg
    libxslt
    perl
    python3Packages.python
    readline
  ] ++ lib.optional enableGestures libstroke;

  pythonPath = [
    python3Packages.pyxdg
  ];

  configureFlags = [
    "--enable-mandoc"
    "--disable-htmldoc"
  ];

  postFixup = ''
    wrapPythonPrograms
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://fvwm.org";
    description = "A multiple large virtual desktop window manager";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ edanaher ];
  };
}
