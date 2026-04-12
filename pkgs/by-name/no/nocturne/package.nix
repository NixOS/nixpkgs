{
  lib,
  fetchFromGitHub,
  python3Packages,
  wrapGAppsHook4,
  gobject-introspection,
  yt-dlp,
  gst_all_1,
  libadwaita,
  glib-networking,
  nix-update-script,

    meson,
    ninja,
    pkg-config,
    desktop-file-utils,
    blueprint-compiler,
    libsecret,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nocturne";
  version = "0.9.5";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Jeffser";
    repo = "Nocturne";
    tag = finalAttrs.version;
    hash = "sha256-xUFg5k58cw0FxUm0bYWvgUncIqvtHQTn+XD/CULWUbo=";
  };

  #sourceRoot = "${finalAttrs.src.name}/src";

  dependencies = with python3Packages; [
    mprisify
    requests
    ytmusicapi
    logboth

    tinytag
    favicon
    pillow
    colorthief
    mpris-server
  ];

  #build-system = with python3Packages; [
  #  setuptools
  #  pip
  #];

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook4

    meson
    ninja
    pkg-config
    desktop-file-utils
    blueprint-compiler
  ];

  buildInputs = [
    libadwaita
    libsecret
    # needed for gstreamer https
    glib-networking
  ]
  ++ (with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gstreamer
  ]);

  #postInstall = ''
  #  make install prefix=$out
  #'';

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ yt-dlp ]}"
      "''${gappsWrapperArgs[@]}"
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Adwaita Music Player / Library Manager for Jellyfin and Navidrome";
    homepage = "https://jeffser.com/nocturne";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.onny ];
    mainProgram = "nocturne";
  };
})
