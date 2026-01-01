{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  python3Packages,
  pango,
  librsvg,
<<<<<<< HEAD
  libxfce4util,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  libxml2,
  menu-cache,
  xorg,
  makeWrapper,
  enableXfcePanelApplet ? false,
<<<<<<< HEAD
  xfce4-panel,
=======
  xfce,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  gtk3,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "jgmenu";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "johanmalm";
    repo = "jgmenu";
    rev = "v${version}";
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
    xorg.libXinerama
    xorg.libXrandr
    python3Packages.python
  ]
  ++ lib.optionals enableXfcePanelApplet [
    gtk3
<<<<<<< HEAD
    libxfce4util
    xfce4-panel
=======
    xfce.libxfce4util
    xfce.xfce4-panel
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/johanmalm/jgmenu";
    description = "Small X11 menu intended to be used with openbox and tint2";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.romildo ];
=======
  meta = with lib; {
    homepage = "https://github.com/johanmalm/jgmenu";
    description = "Small X11 menu intended to be used with openbox and tint2";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.romildo ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
