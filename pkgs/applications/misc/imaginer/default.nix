{
  stdenv,
  lib,
  appstream-glib,
  blueprint-compiler,
  desktop-file-utils,
  fetchFromGitHub,
  gettext,
  glib,
  gobject-introspection,
  libadwaita,
  libsoup_3,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication rec {
  pname = "imaginer";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "ImaginerApp";
    repo = "Imaginer";
    rev = "v${version}";
    hash = "sha256-x1ZnmfaMfxnITiuFDlMPfTU8KZbd1ME9jDevnlsrbJs=";
  };

  format = "other";
  dontWrapGApps = true;

  nativeBuildInputs = [
    appstream-glib
    blueprint-compiler
    desktop-file-utils
    gettext
    glib
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    libadwaita
    libsoup_3
  ];

  propagatedBuildInputs = with python3Packages; [
    openai
    pillow
    pygobject3
    requests
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://github.com/ImaginerApp/Imaginer";
    description = "Imaginer with AI";
    mainProgram = "imaginer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ _0xMRTT ];
  };
}
