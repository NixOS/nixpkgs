{ lib
, pkg-config
, stdenv
, fetchFromGitHub
, autoPatchelfHook
, alsa-lib
, cmake
, freetype
, libGL
, libX11
, libXcursor
, libXext
, libXinerama
, libXrandr
, libjack2
, libopus
, curl
, gtk3
, webkitgtk
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sonobus";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "sonosaurus";
    repo = "sonobus";
    rev = finalAttrs.version;
    hash = "sha256-NOdmHFKrV7lb8XbeG5GdLKYZ0c/vcz3fcqYj9JvE+/Q=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    freetype
    libjack2
    libopus
    curl
    gtk3
    webkitgtk
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
    runHook postInstall
  '';

  meta = with lib; {
    description = "High-quality network audio streaming";
    homepage = "https://sonobus.net/";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ PowerUser64 ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "sonobus";
  };
})
