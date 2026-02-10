{
  lib,
  pkg-config,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  alsa-lib,
  cmake,
  freetype,
  libGL,
  libx11,
  libxcursor,
  libxext,
  libxinerama,
  libxrandr,
  libjack2,
  libopus,
  curl,
  gtk3,
  nix-update-script,
  copyDesktopItems,
  makeDesktopItem,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sonobus";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "sonosaurus";
    repo = "sonobus";
    tag = finalAttrs.version;
    hash = "sha256-NOdmHFKrV7lb8XbeG5GdLKYZ0c/vcz3fcqYj9JvE+/Q=";
    fetchSubmodules = true;
  };

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "sonobus";
      desktopName = "Sonobus";
      comment = "High-quality network audio streaming";
      icon = "sonobus";
      exec = "sonobus";
      categories = [
        "Audio"
        "AudioVideo"
      ];
    })
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    freetype
    libjack2
    libopus
    curl
    gtk3
  ];

  runtimeDependencies = [
    libGL
    libx11
    libxcursor
    libxext
    libxinerama
    libxrandr
  ];

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isLinux "-rpath ${lib.makeLibraryPath (finalAttrs.runtimeDependencies)}";
  dontPatchELF = true; # needed or nix will try to optimize the binary by removing "useless" rpath

  env.NIX_CFLAGS_COMPILE = toString [
    # juce, compiled in this build as part of a Git submodule, uses `-flto` as
    # a Link Time Optimization flag, and instructs the plugin compiled here to
    # use this flag to. This breaks the build for us. Using _fat_ LTO allows
    # successful linking while still providing LTO benefits. If our build of
    # `juce` was used as a dependency, we could have patched that `-flto` line
    # in our juce's source, but that is not possible because it is used as a
    # Git Submodule.
    "-ffat-lto-objects"
  ];

  postPatch = lib.optionalString (stdenv.hostPlatform.isLinux) ''
    patchShebangs linux/install.sh
  '';

  # The program does not provide any CMake install instructions
  installPhase = lib.optionalString (stdenv.hostPlatform.isLinux) ''
    runHook preInstall
    cd ../linux
    ./install.sh "$out"

    install -Dm444 $src/images/sonobus_logo_96.png $out/share/pixmaps/sonobus.png

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High-quality network audio streaming";
    homepage = "https://sonobus.net/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      PowerUser64
      l1npengtul
    ];
    platforms = lib.platforms.unix;
    mainProgram = "sonobus";
  };
})
