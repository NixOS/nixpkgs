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
    owner = "PrismLauncher";
    repo = "libnbtplusplus";
    rev = "23b955121b8217c1c348a9ed2483167a6f3ff4ad";
    hash = "sha256-yy0q+bky80LtK1GWzz7qpM+aAGrOqLuewbid8WT1ilk=";
  };
in
assert lib.assertMsg (
  gamemodeSupport -> stdenv.hostPlatform.isLinux
) "gamemodeSupport is only available on Linux.";
stdenv.mkDerivation (finalAttrs: {
  pname = "prismlauncher-unwrapped";
  version = "9.4";

  src = fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "PrismLauncher";
    tag = finalAttrs.version;
    hash = "sha256-q8ln54nepwbJhC212vGODaafsbOCtdXar7F2NacKWO4=";
  };

  postUnpack = ''
    rm -rf source/libraries/libnbtplusplus
    ln -s ${libnbtplusplus} source/libraries/libnbtplusplus
  '';

  patches = [
    # https://github.com/PrismLauncher/PrismLauncher/pull/3622
    # https://github.com/NixOS/nixpkgs/issues/400119
    (fetchpatch2 {
      name = "fix-qt6.9-compatibility.patch";
      url = "https://github.com/PrismLauncher/PrismLauncher/commit/8bb9b168fb996df9209e1e34be854235eda3d42a.diff";
      hash = "sha256-hOqWBrUrVUhMir2cfc10gu1i8prdNxefTyr7lH6KA2c=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
    extra-cmake-modules
    jdk17
    stripJavaArchivesHook
  ];

  buildInputs = [
    cmark
    ghc_filesystem
    kdePackages.qtbase
    kdePackages.qtnetworkauth
    kdePackages.quazip
    tomlplusplus
    zlib
  ]
  ++ lib.optional gamemodeSupport gamemode;

  hardeningEnable = lib.optionals stdenv.hostPlatform.isLinux [ "pie" ];

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
    description = "Free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with
      their own mods, texture packs, saves, etc) and helps you manage them and
      their associated options with a simple interface.
    '';
    homepage = "https://prismlauncher.org/";
    changelog = "https://github.com/PrismLauncher/PrismLauncher/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      minion3665
      Scrumplex
      getchoo
    ];
    mainProgram = "prismlauncher";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
