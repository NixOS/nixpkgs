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
    .${stdenv.hostPlatform.system}
      or (throw "labrador: unsupported system ${stdenv.hostPlatform.system}");

  libExt = stdenv.hostPlatform.extensions.sharedLibrary;
  # Build directory differs between platforms
  buildDir = if stdenv.hostPlatform.isDarwin then "build_mac" else "build_linux";
in
stdenv.mkDerivation {
  pname = "labrador";
  version = "0-unstable-2026-02-16";

  src = fetchFromGitHub {
    owner = "espotek-org";
    repo = "Labrador";
    rev = "58f6d52452c3b9caf45b099c701f5b4f4e1b8fe2";
    hash = "sha256-LjolfXJIO81iJ5G5SGVh5PYoNpFgV68v/iBlL2WSlho=";
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
          cp ${buildDir}/libdfuprog/lib/libdfuprog-0.9${libExt} $out/lib/
        ''
      else
        ''
          cp ${buildDir}/libdfuprog/lib/${dfuprogArch}/libdfuprog-0.9${libExt} $out/lib/
        ''
    }
  '';

  installPhase = ''
    runHook preInstall

    # Install binary (name differs on macOS)
    mkdir -p $out/bin
  ''
  + (
    if stdenv.hostPlatform.isDarwin then
      ''
        cp Labrador $out/bin/labrador
      ''
    else
      ''
        cp labrador $out/bin/
      ''
  )
  + ''

    mkdir -p $out/share/EspoTek/Labrador/firmware
    cp resources/firmware/labrafirm* $out/share/EspoTek/Labrador/firmware/

    mkdir -p $out/share/EspoTek/Labrador/waveforms
    cp resources/waveforms/* $out/share/EspoTek/Labrador/waveforms/

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/share/icons/hicolor/{48x48,256x256}/apps
      cp build_linux/icon48/espotek-labrador.png $out/share/icons/hicolor/48x48/apps/
      cp build_linux/icon256/espotek-labrador.png $out/share/icons/hicolor/256x256/apps/

      mkdir -p $out/share/applications
      cp build_linux/espotek-labrador.desktop $out/share/applications/

      install -D build_linux/69-labrador.rules $out/lib/udev/rules.d/69-labrador.rules
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

      On NixOS, add `services.udev.packages = [ pkgs.labrador ];` to enable
      non-root USB access to the device.
    '';
    homepage = "https://github.com/espotek-org/Labrador";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ randomizedcoder ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "labrador";
  };
}
