{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  buildGoModule,
  go,
  qt6,
  mpv-unwrapped,
  wrapGAppsHook4,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rssguard";
  version = "5.2.5";

  src = fetchFromGitHub {
    owner = "martinrotter";
    repo = "rssguard";
    tag = finalAttrs.version;
    sha256 = "sha256-Q1TRIBvFWrc2+TdlmsRCWkMM916VGbkXIWnQ6QREn/o=";
    fetchSubmodules = true;
  };

  # Go modules for rssguard-article-extractor, which is built by CMake
  postPatch = ''
    cp -r ${finalAttrs.passthru.goModules} resources/scripts/standalone/article-extractor/vendor
  '';

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtwebengine
    qt6.qttools
    qt6.qt5compat
    mpv-unwrapped
  ];
  nativeBuildInputs = [
    cmake
    go
    wrapGAppsHook4
    qt6.wrapQtAppsHook
    writableTmpDirAsHomeHook
  ];

  # This string must have quotes around Release or the package will break!
  # See https://github.com/NixOS/nixpkgs/issues/563621
  cmakeBuildType = "\"Release\"";

  cmakeFlags = [ (lib.cmakeBool "ENABLE_MEDIAPLAYER_LIBMPV" stdenv.hostPlatform.isLinux) ];

  env.GOFLAGS = "-mod=vendor -trimpath";

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  passthru.goModules =
    (buildGoModule {
      pname = "rssguard-article-extractor";
      inherit (finalAttrs) version src;
      modRoot = "resources/scripts/standalone/article-extractor";
      vendorHash = "sha256-SUwNdHh9XAgX/2Jm0LK8kNjNZNu/1kRuk7/ew2WI3rg=";
    }).goModules;

  meta = {
    description = "Simple RSS/Atom feed reader with online synchronization";
    mainProgram = "rssguard";
    longDescription = ''
      RSS Guard is a simple, light and easy-to-use RSS/ATOM feed aggregator
      developed using Qt framework and with online feed synchronization support
      for ownCloud/Nextcloud.
    '';
    homepage = "https://github.com/martinrotter/rssguard";
    changelog = "https://github.com/martinrotter/rssguard/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      jluttine
      tebriel
    ];
  };
})
