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
let
  libnbtplusplus = fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "libnbtplusplus";
    rev = "3538933614059f0f44388a2b16f3db25ce42285b";
    hash = "sha256-6/8clF2yNhfonV16cfIkxVIzuB9i9ThxoLMxAo/fDuY=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "prismlauncher-unwrapped";
  version = "11.0.3";

  src = fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "PrismLauncher";
    tag = finalAttrs.version;
    hash = "sha256-0o31pLKnYY0mulLrZKzZtaTPzCviGsgCnEcBt0Y/aG4=";
  };

  postUnpack = ''
    rm -rf source/libraries/libnbtplusplus
    ln -s ${libnbtplusplus} source/libraries/libnbtplusplus
  '';

  # Ensure that instance shortucts point to our final wrapper, rather than this unwrapped version
  postPatch = ''
    substituteInPlace launcher/minecraft/ShortcutUtils.cpp \
      --replace-fail 'QApplication::applicationFilePath()' 'QProcessEnvironment::systemEnvironment().value("NIX_LAUNCHER_WRAPPER", "${placeholder "out"}/bin/prismlauncher")'
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
