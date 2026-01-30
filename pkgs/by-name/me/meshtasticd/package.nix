{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchzip,
  libarchive,
  pkg-config,
  platformio-core,
  writableTmpDirAsHomeHook,
  bluez,
  i2c-tools,
  libX11,
  libgpiod_1,
  libinput,
  libusb1,
  libuv,
  libxkbcommon,
  ulfius,
  yaml-cpp,
  udevCheckHook,
  versionCheckHook,
  makeBinaryWrapper,
  python3Packages,
  enableDefaultConfig ? false,
  meshtastic-web, # Only used when `enableDefaultConfig` is set to `true`.
  nixosTests,
}:

assert builtins.isBool enableDefaultConfig;

let
  version = "2.7.18.fb3bf78";

  platformio-deps-native = fetchzip {
    url = "https://github.com/meshtastic/firmware/releases/download/v${version}/platformio-deps-native-tft-${version}.zip";
    hash = "sha256-rud8F+aYVljNw2rpApIkjuN8ob/ZxvcXNJ+oAVSeMpE=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "meshtasticd";
  inherit version;

  src = fetchFromGitHub {
    owner = "meshtastic";
    repo = "firmware";
    hash = "sha256-RI1U0xZDy22C+YO5gKbxo5YWDzVeRWJ8u6tTyDdwqGU=";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    libarchive
    pkg-config
    # This has been advised by the Meshtastic's developer.
    # Without it, it will try to install grpcio-tools by itself and fail.
    (platformio-core.overridePythonAttrs (oldAttrs: {
      dependencies = oldAttrs.dependencies ++ [
        python3Packages.grpcio-tools
      ];
    }))
    writableTmpDirAsHomeHook
    makeBinaryWrapper
  ];

  buildInputs = [
    bluez
    i2c-tools
    libX11
    libgpiod_1
    libinput
    libusb1
    libuv
    libxkbcommon
    ulfius
    yaml-cpp
  ];

  preConfigure = ''
    mkdir -p platformio-deps-native
    cp -ar ${platformio-deps-native}/. platformio-deps-native
    chmod +w -R platformio-deps-native

    export PLATFORMIO_CORE_DIR=platformio-deps-native/core
    export PLATFORMIO_LIBDEPS_DIR=platformio-deps-native/libdeps
    export PLATFORMIO_PACKAGES_DIR=platformio-deps-native/packages
  '';

  buildPhase = ''
    runHook preBuild

    platformio run --environment native-tft

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/share/meshtasticd/config.d
    install -d $out/share/meshtasticd/available.d
    cp -R bin/config.d/* $out/share/meshtasticd/available.d

    install -Dm644 bin/org.meshtastic.meshtasticd.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm644 bin/org.meshtastic.meshtasticd.desktop -t $out/share/applications/
    install -Dm755 .pio/build/native-tft/meshtasticd -t $out/bin

    install -Dm644 bin/99-meshtasticd-udev.rules -t $out/etc/udev/rules.d
  ''
  + lib.optionalString enableDefaultConfig ''
    install -Dm644 bin/config-dist.yaml $out/share/meshtasticd/config.yaml
    substituteInPlace $out/share/meshtasticd/config.yaml \
      --replace-fail "/etc/meshtasticd/config.d" "$out/share/meshtasticd/config.d" \
      --replace-fail "/etc/meshtasticd/available.d" "$out/share/meshtasticd/available.d"
    wrapProgram $out/bin/meshtasticd \
      --add-flags "-c $out/share/meshtasticd/config.yaml"
    install -Dm644 bin/config.d/MUI/X11_480x480.yaml $out/share/meshtasticd/config.d/MUI.yaml
    substituteInPlace $out/share/meshtasticd/config.yaml \
      --replace-fail "/usr/share/meshtasticd/web" "${meshtastic-web}"

    install -d $out/share/meshtasticd/maps
    for file in pio/libdeps/native-tft/meshtastic-device-ui/maps/*.zip; do
      bsdtar -xf "$file" --no-same-owner --strip-components=1 -C $out/share/meshtasticd/maps;
    done
  ''
  + ''
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    udevCheckHook
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  preVersionCheck = ''
    version="${lib.versions.major finalAttrs.version}.${lib.versions.minor finalAttrs.version}.${lib.versions.patch finalAttrs.version}"
  '';

  passthru.tests = {
    inherit (nixosTests) meshtasticd;
  };

  meta = {
    description = "Meshtastic daemon for communicating with Meshtastic devices";
    longDescription = ''
      This package has `udev` rules installed as part of the package.
      Add `services.udev.packages = [ pkgs.meshtasticd ]` into your NixOS
      configuration to enable them.

      To enable the default configuration, set the `enableDefaultConfig` parameter to true.
    '';
    homepage = "https://github.com/meshtastic/firmware";
    mainProgram = "meshtasticd";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
