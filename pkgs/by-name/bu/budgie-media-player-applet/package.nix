{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
  gtk3,
  meson,
  ninja,
  nix-update-script,
  python3Packages,
  xfce,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-media-player-applet";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "zalesyc";
    repo = "budgie-media-player-applet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ekt6OXSjqKF4d6a9lmZyUa06pqz1uYkCHbzvLM7Z+W8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    glib # for `glib-compile-schemas`
    gtk3 # for `gtk-update-icon-theme`
    meson
    ninja
    python3Packages.wrapPython
  ];

  # To be passed to budgie-desktop-with-plugins.
  buildInputs = [
    glib
    gtk3
    xfce.libxfce4windowing
  ];

  pythonPath = with python3Packages; [
    requests
  ];

  mesonFlags = [
    "-Dbudgie-api-v2=true"
  ];

  postPatch = ''
    substituteInPlace meson.build --replace-fail "/usr" "$out"
  '';

  postFixup = ''
    buildPythonPath "$out $pythonPath"
    patchPythonScript "$out/lib/budgie-desktop/plugins/budgie-media-player-applet/applet.py"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Media Control Applet for the Budgie Panel";
    homepage = "https://github.com/zalesyc/budgie-media-player-applet";
    changelog = "https://github.com/zalesyc/budgie-media-player-applet/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.budgie ];
  };
})
