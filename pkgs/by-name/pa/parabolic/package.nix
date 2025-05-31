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
  qt6,
  qlementine,
  qlementine-icons,
  yt-dlp,
  ffmpeg,
  aria2,
  nix-update-script,
  uiPlatform ? "gnome",
}:
assert lib.assertOneOf "uiPlatform" uiPlatform [
  "gnome"
  "qt"
];

stdenv.mkDerivation (finalAttrs: {
  pname = "parabolic";
  version = "2025.5.4";

  src = fetchFromGitHub {
    owner = "NickvisionApps";
    repo = "Parabolic";
    tag = finalAttrs.version;
    hash = "sha256-2CFV9//8gFK1TYksdy9P4nLb7kj/8Q5dr5huoAuDNRs=";
  };

  # Patches desktop file/dbus service bypassing wrapped executable
  postPatch = ''
    substituteInPlace "resources/linux/org.nickvision.tubeconverter.desktop.in" \
      --replace-fail "@CMAKE_INSTALL_FULL_LIBDIR@/@PROJECT_NAME@/@OUTPUT_NAME@" \
                     "@PROJECT_NAME@"

    substituteInPlace "resources/linux/org.nickvision.tubeconverter.service.in" \
      --replace-fail "@CMAKE_INSTALL_FULL_LIBDIR@/@PROJECT_NAME@/@OUTPUT_NAME@" \
                     "@CMAKE_INSTALL_FULL_BINDIR@/@PROJECT_NAME@"
  '';

  nativeBuildInputs =
    [
      cmake
      gettext
      ninja
      pkg-config
      itstool
      yelp-tools
      desktop-file-utils
    ]
    ++ lib.optionals (uiPlatform == "gnome") [
      wrapGAppsHook4
      blueprint-compiler
      glib
      shared-mime-info
    ]
    ++ lib.optional (uiPlatform == "qt") qt6.wrapQtAppsHook;

  buildInputs =
    [
      libnick
      boost
    ]
    ++ lib.optionals (uiPlatform == "qt") [
      qt6.qtbase
      qt6.qtsvg
      qlementine
      qlementine-icons
    ]
    ++ lib.optionals (uiPlatform == "gnome") [
      glib
      gtk4
      libadwaita
      libxmlxx5
    ];

  cmakeFlags = [
    (lib.cmakeFeature "UI_PLATFORM" uiPlatform)
  ];

  dontWrapGApps = true;
  dontWrapQtApps = true;

  preFixup =
    lib.optionalString (uiPlatform == "gnome") ''
      makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
    ''
    + lib.optionalString (uiPlatform == "qt") ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    ''
    + ''
        makeWrapperArgs+=(--prefix PATH : ${
          lib.makeBinPath [
            aria2
            ffmpeg
            yt-dlp
          ]
        })

      wrapProgram $out/bin/org.nickvision.tubeconverter \
        ''${makeWrapperArgs[@]}
    '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Graphical frontend for yt-dlp to download video and audio";
    longDescription = ''
      Parabolic is a user-friendly frontend for `yt-dlp` that supports
      many features including but limited to:
      - Downloading and converting videos and audio using ffmpeg.
      - Supporting multiple codecs.
      - Offering YouTube sponsorblock support.
      - Running multiple downloads at a time.
      - Downloading metadata and video subtitles.
      - Allowing the use of `aria2` for parallel downloads.
      - Offering a graphical keyring to manage account credentials.
      - Being available as both a Qt and GNOME application.

      By default, the GNOME interface is used, but the Qt interface
      can be built by overriding the `uiPlatform` argument to `"qt"`
      over the default value `"gnome"`.
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
