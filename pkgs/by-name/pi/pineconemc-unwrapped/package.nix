{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  cmark,
  gamemode,
  jdk17,
  kdePackages,
  libarchive,
  ninja,
  nix-update-script,
  qrencode,
  stripJavaArchivesHook,
  tomlplusplus,
  vulkan-headers,
  zlib,
  msaClientID ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pineconemc-unwrapped";
  version = "11.1.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ElyPrismLauncher";
    repo = "Launcher";
    tag = finalAttrs.version;
    # pulls libnbtplusplus (git submodule) at the exact commit the fork pins
    fetchSubmodules = true;
    hash = "sha256-0zxviSzoCZkrUu9OZTGQe/+pwyGaklHDZYYeyAquVGw=";
  };

  # Ensure that instance shortcuts point to our final wrapper, rather than this unwrapped version
  postPatch = ''
    substituteInPlace launcher/minecraft/ShortcutUtils.cpp \
      --replace-fail 'QApplication::applicationFilePath()' 'QProcessEnvironment::systemEnvironment().value("NIX_LAUNCHER_WRAPPER", "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}")'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
    kdePackages.extra-cmake-modules
    jdk17
    stripJavaArchivesHook
  ];

  buildInputs = [
    cmark
    kdePackages.qtbase
    kdePackages.qtnetworkauth
    libarchive
    qrencode
    tomlplusplus
    vulkan-headers
    zlib
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux gamemode;

  cmakeFlags = [
    # downstream branding
    (lib.cmakeFeature "Launcher_BUILD_PLATFORM" "nixpkgs")
    # ECM is a build-time tool, so strictDeps hides it from find_package
    (lib.cmakeFeature "ECM_DIR" "${kdePackages.extra-cmake-modules}/share/ECM/cmake")
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
    # the ResourceFolderModel file-watcher test fails in the Darwin sandbox
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;ResourceFolderModel")
  ];

  doCheck = true;

  dontWrapQtApps = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Prism Launcher fork with integrated Ely.by account support";
    longDescription = ''
      Allows you to have multiple, separate instances of Minecraft (each with
      their own mods, texture packs, saves, etc) and helps you manage them and
      their associated options with a simple interface. This fork adds
      integrated support for Ely.by accounts.
    '';
    homepage = "https://pineconemc.ru/";
    changelog = "https://github.com/ElyPrismLauncher/Launcher/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "elyprismlauncher";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ sachin-sankar ];
  };
})
