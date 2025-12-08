{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cmark,
  extra-cmake-modules,
  fetchpatch2,
  qt6Packages,
  gamemode,
  ghc_filesystem,
  jdk17,
  ninja,
  nix-update-script,
  stripJavaArchivesHook,
  tomlplusplus,
  zlib,
  msaClientID ? null,
  gamemodeSupport ? stdenv.hostPlatform.isLinux,
}:

assert lib.assertMsg (
  gamemodeSupport -> stdenv.hostPlatform.isLinux
) "gamemodeSupport is only available on Linux.";
stdenv.mkDerivation (finalAttrs: {
  pname = "projtlauncher";
  version = "0.0.3-3";

  src = fetchFromGitHub {
    owner = "Project-Tick";
    repo = "ProjT-Launcher";
    tag = finalAttrs.version;
    hash = "sha256-KNZkG4uy0dEOSisT5XmLV49th3Q1Uo2vcWJi2UHaYJI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    jdk17
    stripJavaArchivesHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    extra-cmake-modules
  ];

  buildInputs = [
    cmark
    qt6Packages.qtbase
    qt6Packages.qtnetworkauth
    qt6Packages.quazip
    tomlplusplus
    zlib
  ]
  ++ lib.optional gamemodeSupport gamemode;

  cmakeFlags = [
    # downstream branding
    (lib.cmakeFeature "Launcher_BUILD_PLATFORM" "nixpkgs")
  ]
  ++ lib.optionals (msaClientID != null) [
    (lib.cmakeFeature "Launcher_MSA_CLIENT_ID" (toString msaClientID))
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # we wrap our binary manually
    (lib.cmakeFeature "INSTALL_BUNDLE" "nodeps")
    # disable built-in updater
    (lib.cmakeFeature "MACOSX_SPARKLE_UPDATE_FEED_URL" "''")
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/Applications/")
  ];

  doCheck = true;

  dontWrapQtApps = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "A free and open-source Minecraft launcher";
    longDescription = ''
      This application lets you create and manage multiple
      independent Minecraft instances, each with its own
      unique mods, texture packs, worlds, and settings.
      Easily switch between different setups without conflicts,
      keep all your saves and customizations organized, and
      configure options for each instance through a simple and
      intuitive interface. Perfect for players who want to
      experiment with different modpacks, resource packs, or
      gameplay styles while keeping everything neatly separated.
    '';
    homepage = "https://projtlauncher.yongdohyun.org.tr/";
    changelog = "https://github.com/Project-Tick/ProjT-Launcher/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      gpl3Plus
      gpl3Only
      asl20
      cc-by-sa-40
    ];
    maintainers = with lib.maintainers; [
      yongdohyun
    ];
    mainProgram = "projtlauncher";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
