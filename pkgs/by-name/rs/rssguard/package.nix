{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  cmake,
  go,
  icu,
  mpv-unwrapped,
  nix-update-script,
  qt6,
  versionCheckHook,
  wrapGAppsHook4,
  writableTmpDirAsHomeHook,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rssguard";
  version = "5.2.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "martinrotter";
    repo = "rssguard";
    tag = finalAttrs.version;
    hash = "sha256-Q1TRIBvFWrc2+TdlmsRCWkMM916VGbkXIWnQ6QREn/o=";
    fetchSubmodules = true;
  };

  # Go modules for rssguard-article-extractor, which is built by CMake
  postPatch = ''
    cp -r ${finalAttrs.passthru.goModules} resources/scripts/standalone/article-extractor/vendor
  '';

  nativeBuildInputs = [
    cmake
    go
    qt6.wrapQtAppsHook
    wrapGAppsHook4
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    icu
    qt6.qt5compat
    qt6.qtbase
    qt6.qtimageformats
    qt6.qtmultimedia
    qt6.qttools
    qt6.qtwebengine
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    mpv-unwrapped
  ];

  cmakeFlags = [
    (lib.cmakeBool "IS_DEVBUILD" false)
    (lib.cmakeBool "ENABLE_ICU" true)
    (lib.cmakeBool "ENABLE_COMPRESSED_SITEMAP" true)
    (lib.cmakeBool "ENABLE_MEDIAPLAYER_LIBMPV" stdenv.hostPlatform.isLinux)
    (lib.cmakeBool "ENABLE_MEDIAPLAYER_QTMULTIMEDIA" stdenv.hostPlatform.isDarwin)
    (lib.cmakeBool "ENABLE_TESTING" true)
  ]
  ++
    # Plugins are looked up in <bindir>/../${CMAKE_INSTALL_LIBDIR}/rssguard, so it must be relative
    lib.optionals stdenv.hostPlatform.isLinux [
      (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    ]
  # On macOS, everything is installed into Contents/MacOS relative to the prefix
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/Applications/rssguard.app")
    (lib.cmakeFeature "CMAKE_INSTALL_NAME_DIR" "${placeholder "out"}/Applications/rssguard.app/Contents/MacOS")
  ];

  env.GOFLAGS = "-mod=vendor -trimpath";

  dontWrapGApps = true;

  # The hook would also wrap the dylibs installed next to the executable in the bundle
  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    wrapQtApp $out/Applications/rssguard.app/Contents/MacOS/rssguard
    mkdir -p $out/bin
    ln -s $out/Applications/rssguard.app/Contents/MacOS/{rssguard,rssguard-article-extractor} $out/bin/
  '';

  doCheck = true;
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckKeepEnvironment = "HOME QT_QPA_PLATFORM";
  preVersionCheck = ''
    export QT_QPA_PLATFORM=offscreen
  '';

  passthru = {
    goModules =
      (buildGoModule {
        pname = "rssguard-article-extractor";
        inherit (finalAttrs) version src;
        modRoot = "resources/scripts/standalone/article-extractor";
        vendorHash = "sha256-SUwNdHh9XAgX/2Jm0LK8kNjNZNu/1kRuk7/ew2WI3rg=";
      }).goModules;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple RSS/Atom feed reader with online synchronization";
    longDescription = ''
      RSS Guard is a simple, light and easy-to-use RSS/ATOM feed aggregator
      developed using Qt framework and with online feed synchronization support
      for ownCloud/Nextcloud.
    '';
    homepage = "https://github.com/martinrotter/rssguard";
    changelog = "https://github.com/martinrotter/rssguard/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      jluttine
      tebriel
    ];
    mainProgram = "rssguard";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
