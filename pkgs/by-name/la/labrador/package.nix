{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qt5,
  libusb1,
  fftw,
  fftwFloat,
  eigen,
  llvmPackages,
}:

let
  # Map Nix system to the architecture names used in bundled libdfuprog
  dfuprogArch =
    {
      "x86_64-linux" = "x86_64";
      "aarch64-linux" = "arm64";
      "i686-linux" = "i386";
      "armv7l-linux" = "arm";
    }
    .${stdenv.hostPlatform.system} or null;

  # Library file extension differs between platforms
  libExt = if stdenv.hostPlatform.isDarwin then "dylib" else "so";

  # Build directory differs between platforms
  buildDir = if stdenv.hostPlatform.isDarwin then "build_mac" else "build_linux";
in
stdenv.mkDerivation {
  pname = "labrador";
  version = "0-unstable-2026-01-05";

  src = fetchFromGitHub {
    owner = "espotek-org";
    repo = "Labrador";
    rev = "3119205cdde183039062621c1204584f1ec1c5ac";
    hash = "sha256-GREfHgwRk6qTWEG8kVVP2v7X28L5x9vIsBmziOTNpvQ=";
  };

  nativeBuildInputs = [
    pkg-config
    qt5.wrapQtAppsHook
    qt5.qmake
  ];

  buildInputs = [
    qt5.qtbase
    libusb1
    fftw
    fftwFloat
    eigen
    llvmPackages.openmp
  ];

  preConfigure = ''
    cd Desktop_Interface

    # Create library directory for bundled libdfuprog
    mkdir -p $out/lib

    # Copy the appropriate libdfuprog for this platform/architecture
    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          if [ -f "${buildDir}/libdfuprog/lib/libdfuprog-0.9.${libExt}" ]; then
            cp ${buildDir}/libdfuprog/lib/libdfuprog-0.9.${libExt} $out/lib/
          fi
        ''
      else
        lib.optionalString (dfuprogArch != null) ''
          if [ -f "${buildDir}/libdfuprog/lib/${dfuprogArch}/libdfuprog-0.9.${libExt}" ]; then
            cp ${buildDir}/libdfuprog/lib/${dfuprogArch}/libdfuprog-0.9.${libExt} $out/lib/
          fi
        ''
    }
  '';

  configurePhase = ''
    runHook preConfigure
    qmake PREFIX=$out
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    make -j$NIX_BUILD_CORES
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Install binary (name differs on macOS)
    mkdir -p $out/bin
    if [ -f labrador ]; then
      cp labrador $out/bin/
    elif [ -f Labrador ]; then
      cp Labrador $out/bin/labrador
    fi

    # Install firmware
    mkdir -p $out/share/EspoTek/Labrador/firmware
    cp resources/firmware/labrafirm* $out/share/EspoTek/Labrador/firmware/

    # Install waveforms
    mkdir -p $out/share/EspoTek/Labrador/waveforms
    cp resources/waveforms/* $out/share/EspoTek/Labrador/waveforms/

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      # Install icons (Linux only)
      mkdir -p $out/share/icons/hicolor/48x48/apps
      mkdir -p $out/share/icons/hicolor/256x256/apps
      cp build_linux/icon48/espotek-labrador.png $out/share/icons/hicolor/48x48/apps/
      cp build_linux/icon256/espotek-labrador.png $out/share/icons/hicolor/256x256/apps/

      # Install desktop file (Linux only)
      mkdir -p $out/share/applications
      cp build_linux/espotek-labrador.desktop $out/share/applications/
    ''}

    runHook postInstall
  '';

  # Wrap the executable to find libdfuprog
  preFixup =
    if stdenv.hostPlatform.isDarwin then
      ''
        qtWrapperArgs+=(--prefix DYLD_LIBRARY_PATH : "$out/lib")
      ''
    else
      ''
        qtWrapperArgs+=(--prefix LD_LIBRARY_PATH : "$out/lib")
      '';

  meta = {
    description = "EspoTek Labrador - oscilloscope, signal generator, logic analyzer, and more";
    longDescription = ''
      The EspoTek Labrador is an open-source board that turns your PC into a
      full-featured electronics lab bench, complete with oscilloscope, signal
      generator, logic analyzer, and more. This package provides the Qt5
      desktop application for interfacing with the Labrador hardware.
    '';
    homepage = "https://github.com/espotek-org/Labrador";
    license = lib.licenses.gpl3Only;
    # maintainers = with lib.maintainers; [ randomizedcoder ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "labrador";
  };
}
