{
  lib,
  fetchFromGitHub,
  wrapGAppsHook4,
  meson,
  ninja,
  pkg-config,
  appstream-glib,
  desktop-file-utils,
  gobject-introspection,
  glib,
  blueprint-compiler,
  libadwaita,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "halftone";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "tfuxu";
    repo = "halftone";
    tag = version;
    hash = "sha256-UpYdOYQa98syDI353+c/JN9/68PraQ8bg05GES46C+A=";
  };

  format = "other";
  dontWrapGApps = true;

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    glib
    gobject-introspection
  ];

  buildInputs = [
    libadwaita
  ];

  propagatedBuildInputs = with python3Packages; [
    pygobject3
    wand
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://github.com/tfuxu/halftone";
    description = "Simple app for giving images that pixel-art style";
    license = licenses.gpl3Plus;
    mainProgram = "halftone";
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = platforms.linux;
  };
}
