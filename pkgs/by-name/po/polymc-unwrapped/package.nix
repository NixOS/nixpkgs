{
  stdenv,
  fetchFromGitHub,
  fetchurl,
  lib,
  cmake,
  ninja,
  jdk8,
  gamemode,
  mangohud,
  zlib,
  file,
  qt6Packages,
  kdePackages,
  tomlplusplus,
  ghc_filesystem,
  msaClientID ? null,
  msaRequired ? true,
  gamemodeSupport ? stdenv.isLinux,
  mangohudSupport ? stdenv.isLinux,
  enableLTO ? false,
}:

/*
    Feel free to override msaRequired to `false' on your machine, as
    it's intended to NOT require an account to use the launcher.

    It's set to true by default to avoid any piracy-related discussion.
*/

stdenv.mkDerivation (finalAttrs: {
  pname = "polymc-unwrapped";
  version = "7.0-unstable-2026-03-04";

  libnbtplusplus = fetchFromGitHub {
    owner = "PolyMC";
    repo = "libnbtplusplus";
    rev = "2203af7eeb48c45398139b583615134efd8d407f";
    hash = "sha256-TvVOjkUobYJD9itQYueELJX3wmecvEdCbJ0FinW2mL4=";
  };

  /*
    Gated so it only pulls when you're on Darwin.
    Make sure the hash matches the one in CMakeLists!
  */

  sparkle =
    if stdenv.hostPlatform.isDarwin then
      fetchurl {
        url = "https://github.com/sparkle-project/Sparkle/releases/download/2.1.0/Sparkle-2.1.0.tar.xz";
        hash = "sha256-v2rByqn40yHVeEhZyI2odPKEEvN/sye8IbexTF1h75Q=";
      }
    else
      null;

  src = fetchFromGitHub {
    owner = "PolyMC";
    repo = "PolyMC";
    rev = "49e06691c47b6ed55f0306771c2dada301733b79";
    hash = "sha256-K70TMZet+y4qPu0c8HZZDwuQIEhENP6XDjRzBptAiQI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    jdk8
    file
  ];

  buildInputs = [
    qt6Packages.qtbase
    qt6Packages.quazip
    qt6Packages.qtcharts
    zlib

    tomlplusplus
    ghc_filesystem
    kdePackages.extra-cmake-modules
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6Packages.qtwayland
    qt6Packages.qt6ct
  ]
  ++ lib.optional gamemodeSupport gamemode;

  dontWrapQtApps = true;
  doCheck = true;
  strictDeps = true;
  __structuredAttrs = true;

  postUnpack = ''
    rm -rf source/libraries/libnbtplusplus
    ln -s ${finalAttrs.libnbtplusplus} source/libraries/libnbtplusplus
  '';

  substituteBuildConfigCppFlags = [
    "--replace-fail"
    "return vstr;"
    "return vstr + \"+NixOS\";"
  ]
  ++ lib.optionals ((finalAttrs.src.rev or null) != null) [
    "--replace-fail"
    "@Launcher_GIT_COMMIT@"
    finalAttrs.src.rev
  ]
  ++ lib.optionals ((finalAttrs.src.tag or null) != null) [
    "--replace-fail"
    "@Launcher_GIT_TAG@"
    finalAttrs.src.tag
  ]
  ++ lib.optionals ((finalAttrs.src.ref or null) != null) [
    "--replace-fail"
    "@Launcher_GIT_REFSPEC@"
    finalAttrs.src.ref
  ];

  # This is for metadata & branding.
  postPatch = ''
    if [ ''${#substituteBuildConfigCppFlags[@]} -gt 0 ]; then
      substituteInPlace buildconfig/BuildConfig.cpp.in "''${substituteBuildConfigCppFlags[@]}"
    fi
  ''
  # APPLE branch hardcodes INSTALL_BUNDLE=full (bundles Qt via fixup_bundle,
  # conflicting with nixpkgs' wrapped Qt); force nodeps.
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'set(INSTALL_BUNDLE "full")' 'set(INSTALL_BUNDLE "nodeps")'
  '';

  cmakeFlags = [
    (lib.cmakeFeature "Launcher_QT_VERSION_MAJOR" (lib.versions.major qt6Packages.qtbase.version))
    (lib.cmakeFeature "Launcher_BUILD_PLATFORM" "nixpkgs")
    (lib.cmakeBool "ENABLE_LTO" enableLTO)
    (lib.cmakeBool "Launcher_STRICT_DRM" msaRequired)
  ]
  ++ lib.optional (msaClientID != null) (lib.cmakeFeature "Launcher_MSA_CLIENT_ID" msaClientID)
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Inert auto-updater feed; source Sparkle from the vendored copy.
    (lib.cmakeFeature "MACOSX_SPARKLE_UPDATE_FEED_URL" "")
    (lib.cmakeFeature "MACOSX_SPARKLE_DOWNLOAD_URL" "file://${finalAttrs.sparkle}")
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/Applications/")
  ];

  meta = {
    homepage = "https://polymc.org/";
    downloadPage = "https://polymc.org/download/";
    changelog =
      "https://github.com/PolyMC/PolyMC/releases"
      + lib.optionalString ((finalAttrs.src.tag or null) != null) "/tag/${finalAttrs.src.tag}";
    description = "A free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have and manage multiple, separate instances of Minecraft with a simple interface.
      The contents of each instance are separate. That includes mods, texture packs, saves, etc.
    '';
    problems =
      lib.optionalAttrs (!stdenv.hostPlatform.isLinux && gamemodeSupport) {
        broken.message = "${gamemode.pname} is only supported on Linux.";
      }
      // lib.optionalAttrs (!stdenv.hostPlatform.isLinux && mangohudSupport) {
        broken.message = "${mangohud.pname} is only supported on Linux.";
      };
    platforms = [
      "x86_64-freebsd"
    ]
    ++ lib.platforms.linux
    ++ lib.platforms.darwin
    ++ lib.platforms.windows;
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      hustlerone
    ];
  };
})
