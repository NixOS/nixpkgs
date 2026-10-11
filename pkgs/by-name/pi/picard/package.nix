{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,

  gettext,
  qt6,
  wrapGAppsHook3,

  gst_all_1,
  chromaprint,

  writableTmpDirAsHomeHook,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "picard";
  version = "3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "metabrainz";
    repo = "picard";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-aUiXmiGZTg2nQtHlE8B1/DFgvK5jLVOzN8i21fPsNk4=";
  };

  nativeBuildInputs = [
    gettext
    qt6.wrapQtAppsHook
    python3Packages.setuptools
    wrapGAppsHook3
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform qt6.qtwayland) [
    qt6.qtwayland
  ];

  dependencies = [
    chromaprint # Not strictly required, but added for fpcalc in the wrapper
  ]
  ++ (
    with python3Packages;
    [
      charset-normalizer
      discid
      markdown
      mutagen
      pyjwt
      pyqt6
      pygit2
      pyyaml
      tomlkit
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      pyobjc-core
      pyobjc-framework-Cocoa
    ]
  );

  # Not reporting any of these issues upstream since they are all caused by
  # the restricted darwin build sandbox (no real $HOME, no access to
  # /var/empty/Library, no SetFile utility), not by picard itself.
  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    "_macos"
    "TestListenQueue"
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    writableTmpDirAsHomeHook
  ];
  doCheck = true;

  env = {
    # pygit2 needs this to initialize its TLS settings, otherwise importing
    # it fails during the tests; also baked into the wrapper below for
    # runtime, and for versionCheckHook.
    inherit (python3Packages.pygit2) SSL_CERT_FILE;
  };

  # In order to spare double wrapping, we use:
  dontWrapGApps = true;
  dontWrapQt = true;
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  ''
  + lib.optionalString (lib.meta.availableOn stdenv.hostPlatform qt6.qtwayland) ''
    makeWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "release-(.*)"
    ];
  };

  meta = {
    homepage = "https://picard.musicbrainz.org";
    changelog = "https://picard.musicbrainz.org/changelog";
    description = "Official MusicBrainz tagger";
    mainProgram = "picard";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
