{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
  itstool,
  ninja,
  yelp-tools,
  desktop-file-utils,
  pkg-config,
  libnick,
  boost,
  glib,
  shared-mime-info,
  gtk4,
  libadwaita,
  wrapGAppsHook4,
  libxmlxx5,
  blueprint-compiler,
  yt-dlp,
  ffmpeg,
  aria2,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "parabolic";
  version = "2025.11.1";

  src = fetchFromGitHub {
    owner = "NickvisionApps";
    repo = "Parabolic";
    tag = finalAttrs.version;
    hash = "sha256-PNV7hdaP5F/VuaNH3trtJ8oQqLEps/oE6p34LgJ/tEs=";
  };

  # Patches desktop file/dbus service bypassing wrapped executable
  postPatch = ''
    substituteInPlace "resources/linux/org.nickvision.tubeconverter.desktop.in" \
      --replace-fail "@CMAKE_INSTALL_FULL_LIBDIR@/@PROJECT_NAME@/@OUTPUT_NAME@" \
                     "@PROJECT_NAME@"

    substituteInPlace "resources/linux/org.nickvision.tubeconverter.service.in" \
      --replace-fail "@CMAKE_INSTALL_FULL_LIBDIR@/@PROJECT_NAME@/@OUTPUT_NAME@" \
                     "@CMAKE_INSTALL_FULL_BINDIR@/@PROJECT_NAME@"
  ''
  # Ensure that users are not downloading vendored versions of yt-dlp
  # outside of nixpkgs
  + ''
    substituteInPlace "libparabolic/src/models/downloadmanager.cpp" \
      --replace-fail "m_ytdlpManager.checkForUpdates();" \
                     ""
  '';

  nativeBuildInputs = [
    cmake
    gettext
    ninja
    pkg-config
    itstool
    yelp-tools
    desktop-file-utils
    wrapGAppsHook4
    blueprint-compiler
    glib
    shared-mime-info
  ];

  buildInputs = [
    libnick
    boost
    glib
    gtk4
    libadwaita
    libxmlxx5
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        aria2
        ffmpeg
        yt-dlp
      ]
    })
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Graphical frontend for yt-dlp to download video and audio";
    longDescription = ''
      Parabolic is a user-friendly adwaita application for `yt-dlp`
      that supports many features including but not limited to:

      - Downloading and converting videos and audio using ffmpeg.
      - Supporting multiple codecs.
      - Offering YouTube sponsorblock support.
      - Running multiple downloads at a time.
      - Downloading metadata and video subtitles.
      - Allowing the use of `aria2` for parallel downloads.
      - Offering a graphical keyring to manage account credentials.
    '';
    homepage = "https://github.com/NickvisionApps/Parabolic";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      normalcea
      getchoo
    ];
    mainProgram = "org.nickvision.tubeconverter";
    platforms = lib.platforms.linux;
  };
})
