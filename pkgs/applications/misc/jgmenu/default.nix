{ lib, stdenv
, fetchFromGitHub
, pkg-config
, python3Packages
, pango
, librsvg
, libxml2
, menu-cache
, xorg
, makeWrapper
, enableXfcePanelApplet ? false
, xfce
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "jgmenu";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "johanmalm";
    repo = pname;
    rev = "v${version}";
    sha256 = "00q4v31x4q7nm61wda4v0gznv18bm3qs8mp04pcns60qacdv9lkk";
  };

  nativeBuildInputs = [
    pkg-config
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
  ] ++ lib.optionals enableXfcePanelApplet [
    gtk3
    xfce.libxfce4util
    xfce.xfce4-panel
  ];

  configureFlags = [
  ]
  ++ lib.optionals enableXfcePanelApplet [
    "--with-xfce4-panel-applet"
  ];

  postFixup = ''
    wrapPythonProgramsIn "$out/lib/jgmenu"
    for f in $out/bin/jgmenu{,_run}; do
      wrapProgram $f --prefix PATH : $out/bin
    done
  '';

  meta = with lib; {
    homepage = "https://github.com/johanmalm/jgmenu";
    description = "Small X11 menu intended to be used with openbox and tint2";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
  };
}
