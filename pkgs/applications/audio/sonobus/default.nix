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

stdenv.mkDerivation rec {
  pname = "sonobus";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "sonosaurus";
    repo = "sonobus";
    rev = version;
    sha256 = "sha256-/Pb+PYmoCYA6Qcy/tR1Ejyt+rZ3pfJeWV4j7bQWYE58=";
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

  postPatch = lib.optionalString (stdenv.isLinux) ''
    # needs special setup on Linux, dunno if it can work on Darwin
    # https://github.com/NixOS/nixpkgs/issues/19098
    # Also, I get issues with linking without that, not sure why
    sed -i -e '/juce::juce_recommended_lto_flags/d' CMakeLists.txt
    patchShebangs linux/install.sh
  '';

  # The program does not provide any CMake install instructions
  installPhase = lib.optionalString (stdenv.isLinux) ''
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
    broken = stdenv.isDarwin;
  };
}
