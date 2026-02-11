{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  python3Packages,
  pango,
  librsvg,
  libxfce4util,
  libxml2,
  menu-cache,
  libxrandr,
  libxinerama,
  makeWrapper,
  enableXfcePanelApplet ? false,
  xfce4-panel,
  gtk3,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jgmenu";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "johanmalm";
    repo = "jgmenu";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-vuSpiZZYe0l5va9dHM54gaoI9x8qXH1gJORUS5489jQ=";
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
    libxinerama
    libxrandr
    python3Packages.python
  ]
  ++ lib.optionals enableXfcePanelApplet [
    gtk3
    libxfce4util
    xfce4-panel
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

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://github.com/johanmalm/jgmenu";
    description = "Small X11 menu intended to be used with openbox and tint2";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
  };
})
