{
  desktop-file-utils,
  fetchFromForgejo,
  gobject-introspection,
  gtk4,
  libadwaita,
  lib,
  meson,
  ninja,
  python3Packages,
  wrapGAppsHook4,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "CoverGrid";
  version = "4.0.2";

  format = "other";

  src = fetchFromForgejo {
    domain = "git.suruatoel.xyz";
    owner = "coderkun";
    repo = "mcg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zQAsfUcf7MYxaujIVlHsc2D/1t9aDh0gH3c+3CwL7Wg=";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    desktop-file-utils # for update-desktop-database
    gobject-introspection
    gtk4
    wrapGAppsHook4
    meson
    ninja
  ];

  buildInputs = [
    libadwaita
  ];

  dependencies = with python3Packages; [
    pygobject3
    python-dateutil
    keyring
    avahi
  ];

  # Avoid double wrapped binaries. See "When using wrapGApps* hook with special
  # derivers or hooks you can end up with double wrapped binaries" in the Nixpkgs reference manual.
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Client for the Music Player Daemon (MPD), focusing on albums instead of single tracks";
    longDescription = ''
      Client for the Music Player Daemon (MPD), focusing on albums instead of single tracks.
      Also known as CoverGrid.
    '';
    homepage = "https://www.suruatoel.xyz/codes/mcg";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jfly ];
    platforms = lib.platforms.all;
    mainProgram = "mcg";
  };
})
