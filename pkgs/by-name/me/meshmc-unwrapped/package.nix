{
  lib,
  stdenv,
  fetchurl,
  cmake,
  cmark,
  extra-cmake-modules,
  jdk17,
  kdePackages,
  libarchive,
  ninja,
  nix-update-script,
  stripJavaArchivesHook,
  vulkan-headers,
  zlib,
  msaClientID ? null,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "meshmc-unwrapped";
  version = "7.0.1";
  snapshottag = "v202604131638";

  src = fetchurl {
    url = "https://github.com/Project-Tick/Project-Tick/releases/download/${finalAttrs.snapshottag}/meshmc-${finalAttrs.snapshottag}.tar.gz";
    hash = "sha256-YSrU0dx0ILMcKKP71pPfCUB0Z8IefIgEX21lb7sH6kw=";
  };

  strictDeps = true;
  __structuredAttrs = true;

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
    libarchive
    vulkan-headers
    zlib
  ];

  postInstall = ''
    rm -f $out/bin/meshmc-updater
  '';

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
      their associated options with a simple interface. (Fork of MultiMC, not
      prism or PolyMC)
    '';
    homepage = "https://projecttick.org/p/meshmc";
    changelog = "https://projecttick.org/product/meshmc/news/release-${finalAttrs.version}";
    license = with lib.licenses; [
      # MeshMC License
      gpl3Plus
      # Original MultiMC license
      asl20
      # Some Prism Launcher and MeshMC assets
      cc-by-sa-40
      # LibNBT++, Oxygen Icons
      lgpl3Plus
      # rainbow
      lgpl2Plus
      # qdcss
      lgpl3Only
      # Material Design Icons
      ofl
      # lionshead
      mit
      # LocalPeer
      bsd3
      # Batch Icons
      batchLicense
      # murmur2
      publicDomain
    ];
    maintainers = with lib.maintainers; [
      yongdohyun
    ];
    mainProgram = "meshmc";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
