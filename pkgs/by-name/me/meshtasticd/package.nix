{
<<<<<<< HEAD
  stdenv,
  lib,
  fetchFromGitHub,
  fetchzip,
  libarchive,
  pkg-config,
  platformio-core,
  writableTmpDirAsHomeHook,
  bluez,
=======
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  i2c-tools,
  libX11,
  libgpiod_1,
  libinput,
  libusb1,
  libuv,
  libxkbcommon,
<<<<<<< HEAD
  ulfius,
  openssl,
  gnutls,
  jansson,
  zlib,
  libmicrohttpd,
  orcania,
  yder,
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
  version = "2.7.16.a597230";

  platformio-deps-native = fetchzip {
    url = "https://github.com/meshtastic/firmware/releases/download/v${version}/platformio-deps-native-tft-${version}.zip";
    hash = "sha256-Jo7e6zsCaiJs6NyIRmD6BWJFwbs0xVlUih206ePUpwk=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "meshtasticd";
  inherit version;

  src = fetchFromGitHub {
    owner = "meshtastic";
    repo = "firmware";
    hash = "sha256-oU3Z8qjBNeNGPGT74VStAPHgsGqsQJKngHJR6m2CBa0=";
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
    gnutls
    i2c-tools
    jansson
    libX11
    libgpiod_1
    libinput
    libmicrohttpd
    libusb1
    libuv
    libxkbcommon
    openssl
    orcania
    ulfius
    yaml-cpp
    yder
    zlib
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
=======
  udevCheckHook,
  ulfius,
  yaml-cpp,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "meshtasticd";
  version = "2.6.11.25";

  src = fetchurl {
    url = "https://download.opensuse.org/repositories/network:/Meshtastic:/beta/Debian_12/amd64/meshtasticd_${finalAttrs.version}~obs60ec05e~beta_amd64.deb";
    hash = "sha256-7JCv+1YgsCLwboGE/2f+8iyLLoUsKn3YdJ9Atnfj7Zw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  dontConfigure = true;
  dontBuild = true;

  strictDeps = true;

  buildInputs = [
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

  autoPatchelfIgnoreMissingDeps = [
    "libyaml-cpp.so.0.7"
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  installPhase = ''
    runHook preInstall

<<<<<<< HEAD
    install -d $out/share/meshtasticd/config.d
    install -d $out/share/meshtasticd/available.d
    cp -R bin/config.d/* $out/share/meshtasticd/available.d

    install -Dm644 bin/org.meshtastic.meshtasticd.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm644 bin/org.meshtastic.meshtasticd.desktop -t $out/share/applications/
    install -Dm755 .pio/build/native-tft/program $out/bin/meshtasticd

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
=======
    mkdir -p {$out,$out/bin}
    cp -r {usr,lib} $out/

    patchelf --replace-needed libyaml-cpp.so.0.7 libyaml-cpp.so.0.8 $out/usr/bin/meshtasticd

    ln -s $out/usr/bin/meshtasticd $out/bin/meshtasticd

    substituteInPlace $out/lib/systemd/system/meshtasticd.service \
      --replace-fail "/usr/bin/meshtasticd" "$out/bin/meshtasticd" \
      --replace-fail 'User=meshtasticd' 'DynamicUser=yes' \
      --replace-fail 'Group=meshtasticd' ""

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    runHook postInstall
  '';

  doInstallCheck = true;
<<<<<<< HEAD
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
=======
  nativeInstallCheckInputs = [ udevCheckHook ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Meshtastic daemon for communicating with Meshtastic devices";
    longDescription = ''
      This package has `udev` rules installed as part of the package.
      Add `services.udev.packages = [ pkgs.meshtasticd ]` into your NixOS
      configuration to enable them.
<<<<<<< HEAD

      To enable the default configuration, set the `enableDefaultConfig` parameter to true.
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    '';
    homepage = "https://github.com/meshtastic/firmware";
    mainProgram = "meshtasticd";
    license = lib.licenses.gpl3Plus;
<<<<<<< HEAD
    platforms = lib.platforms.linux;
=======
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = with lib.maintainers; [ drupol ];
  };
})
