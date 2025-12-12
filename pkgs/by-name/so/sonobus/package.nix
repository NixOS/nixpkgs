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
  libX11,
  libXcursor,
  libXext,
  libXinerama,
  libXrandr,
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
    libX11
    libXcursor
    libXext
    libXinerama
    libXrandr
  ];

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isLinux "-rpath ${lib.makeLibraryPath (finalAttrs.runtimeDependencies)}";
  dontPatchELF = true; # needed or nix will try to optimize the binary by removing "useless" rpath

  postPatch = lib.optionalString (stdenv.hostPlatform.isLinux) ''
    # needs special setup on Linux, dunno if it can work on Darwin
    # Also, I get issues with linking without that, not sure why
    sed -i -e '/juce::juce_recommended_lto_flags/d' CMakeLists.txt
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
