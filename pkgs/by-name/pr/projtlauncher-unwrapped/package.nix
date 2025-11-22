{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cmark,
  extra-cmake-modules,
  fetchpatch2,
  gamemode,
  ghc_filesystem,
  jdk17,
  kdePackages,
  ninja,
  nix-update-script,
  stripJavaArchivesHook,
  tomlplusplus,
  zlib,
  msaClientID ? null,
  gamemodeSupport ? stdenv.hostPlatform.isLinux,
}:
let
  libnbtplusplus = fetchFromGitHub {
    owner = "Project-Tick";
    repo = "libnbtplusplus";
    rev = "23b955121b8217c1c348a9ed2483167a6f3ff4ad";
    hash = "sha256-yy0q+bky80LtK1GWzz7qpM+aAGrOqLuewbid8WT1ilk=";
  };
in
assert lib.assertMsg (
  gamemodeSupport -> stdenv.hostPlatform.isLinux
) "gamemodeSupport is only available on Linux.";
stdenv.mkDerivation (finalAttrs: {
  pname = "projtlauncher";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "Project-Tick";
    repo = "ProjT-Launcher";
    tag = finalAttrs.version;
    sha256 = "sha256-wTyhOHNaxfrBNTa9cqK8oA4Nw5Rj8lPONjOrkSYwVjM=";
    fetchSubmodules = true;
  };

  postUnpack = ''
    rm -rf source/libraries/libnbtplusplus
    ln -s ${libnbtplusplus} source/libraries/libnbtplusplus
  '';

  nativeBuildInputs = [
    cmake
    ninja
    extra-cmake-modules
    jdk17
    stripJavaArchivesHook
  ];

  buildInputs = [
    cmark
    kdePackages.qtbase
    kdePackages.qtnetworkauth
    kdePackages.quazip
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
  ++ lib.optionals (lib.versionOlder kdePackages.qtbase.version "6") [
    (lib.cmakeFeature "Launcher_QT_VERSION_MAJOR" "5")
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
    description = "ProjT‑Launcher lets you manage Minecraft versions, mods, and worlds, standing out with new and upcoming features.";
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
