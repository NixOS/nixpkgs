{ stdenv
, lib
, fetchFromGitHub
, appstream-glib
, blueprint-compiler
, desktop-file-utils
, glib
, gettext
, gobject-introspection
, libadwaita
, meson
, ninja
, pkg-config
, python3Packages
, wrapGAppsHook4
}:

python3Packages.buildPythonApplication rec {
  pname = "bavarder";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Bavarder";
    repo = "Bavarder";
    rev = "0.1.0";
    hash = "sha256-jeb9a99/wIzcKxklv/Z7DC6PlstrCPkTBFq1F5KiTMI=";
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
  ];

  propagatedBuildInputs = with python3Packages; [
    baichat-py
    lxml
    pygobject3
  ];

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://github.com/Bavarder/Bavarder";
    description = "Chit-chat with GPT ";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ _0xMRTT ];
  };
}
