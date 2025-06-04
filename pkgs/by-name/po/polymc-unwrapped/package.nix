{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cmark,
  extra-cmake-modules,
  gamemode,
  ghc_filesystem,
  jdk8,
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
    owner = "PolyMC";
    repo = "libnbtplusplus";
    rev = "2203af7eeb48c45398139b583615134efd8d407f";
    hash = "sha256-TvVOjkUobYJD9itQYueELJX3wmecvEdCbJ0FinW2mL4=";
  };
in

assert lib.assertMsg (
  gamemodeSupport -> stdenv.hostPlatform.isLinux
) "gamemodeSupport is only available on Linux.";

stdenv.mkDerivation (finalAttrs: {
  pname = "polymc-unwrapped";
  version = "7.0";

  src = fetchFromGitHub {
    owner = "PolyMC";
    repo = "PolyMC";
    tag = finalAttrs.version;
    hash = "sha256-d6Npu21iC5JUhWOM2DMn7gtzOj/Oo+ZoB36birHxzyA=";
  };

  postUnpack = ''
    rm -rf source/libraries/libnbtplusplus
    ln -s ${libnbtplusplus} source/libraries/libnbtplusplus
  '';

  nativeBuildInputs = [
    cmake
    ninja
    extra-cmake-modules
    jdk8
    stripJavaArchivesHook
  ];

  buildInputs = [
    cmark
    ghc_filesystem
    kdePackages.qtbase
    kdePackages.qtcharts
    kdePackages.quazip
    tomlplusplus
    zlib
  ] ++ lib.optional gamemodeSupport gamemode;

  hardeningEnable = lib.optionals stdenv.hostPlatform.isLinux [ "pie" ];

  cmakeFlags =
    [
      (lib.cmakeFeature "Launcher_BUILD_PLATFORM" "nixpkgs")
      (lib.cmakeFeature "Launcher_QT_VERSION_MAJOR" (lib.versions.major kdePackages.qtbase.version))
    ]
    ++ lib.optionals (msaClientID != null) [
      (lib.cmakeFeature "Launcher_MSA_CLIENT_ID" (toString msaClientID))
    ];

  doCheck = true;

  dontWrapQtApps = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://polymc.org/";
    downloadPage = "https://polymc.org/download/";
    changelog = "https://github.com/PolyMC/PolyMC/releases/tag/${finalAttrs.version}";
    description = "A free, open source launcher for Minecraft";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with
      their own mods, texture packs, saves, etc) and helps you manage them and
      their associated options with a simple interface.
    '';
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    mainProgram = "polymc";
    maintainers = [ lib.maintainers.orvitpng ];
  };
})
