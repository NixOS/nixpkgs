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
    owner = "FreesmTeam";
    repo = "libnbtplusplus";
    rev = "687e43031df0dc641984b4256bcca50d5b3f7de3";
    hash = "sha256-7itkptyjoRcXfGLwg1/jxajetZ3a4mDc66+w4X6yW8s=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "freesmlauncher-unwrapped";
  version = "2.2.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "FreesmTeam";
    repo = "FreesmLauncher";
    tag = finalAttrs.version;
    hash = "sha256-FPBifWh/1hOhUpEl+eoB685T9lP5lSA9FQHQeFBJu24=";
  };

  postUnpack = ''
    rm -rf source/libraries/libnbtplusplus
    ln -s ${libnbtplusplus} source/libraries/libnbtplusplus
  '';

  # Ensure that instance shortcuts point to our final wrapper, rather than this unwrapped version
  postPatch = ''
    substituteInPlace launcher/minecraft/ShortcutUtils.cpp \
      --replace-fail 'QApplication::applicationFilePath()' 'QProcessEnvironment::systemEnvironment().value("NIX_LAUNCHER_WRAPPER", "${placeholder "out"}/bin/freesmlauncher")'
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
    kdePackages.extra-cmake-modules
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
    description = "Prism Launcher fork aimed to provide a free way to play Minecraft";
    longDescription = ''
      Freesm Launcher is a custom launcher for Minecraft that allows you
      to easily manage multiple installations of Minecraft at once and login
      with offline account without any restrictions.
    '';
    homepage = "https://freesmlauncher.org/";
    changelog = "https://github.com/FreesmTeam/FreesmLauncher/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mio ];
    mainProgram = "freesmlauncher";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
