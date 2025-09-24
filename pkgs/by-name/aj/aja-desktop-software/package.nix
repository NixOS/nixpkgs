{
  stdenvNoCC,
  lib,
  fetchzip,
  dpkg,
  patchelf,
  buildFHSEnv,
  writeShellScript,
  makeBinaryWrapper,
}:

let
  pname = "aja-desktop-software";
  version = "17.1.3";
  meta = {
    description = "Graphical utilities for interacting with AJA desktop video cards";
    homepage = "https://www.aja.com/products/aja-control-room";
    license = lib.licenses.unfree; # https://www.aja.com/software-license-agreement
    maintainers = [ lib.maintainers.lukegb ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [
      lib.sourceTypes.binaryNativeCode
      lib.sourceTypes.binaryFirmware
    ];
  };

  unwrapped = stdenvNoCC.mkDerivation {
    pname = "${pname}-unwrapped";
    inherit version;

    src = fetchzip {
      url = "https://www.aja.com/assets/support/files/9895/en/AJA-Desktop-Software-Installer_Linux-Ubuntu_v${version}_Release.zip";
      hash = "sha256-TxDcYIhEcpPnpoqpey5vSvUltLT/3xwBfOhAP81Q9+E=";
    };

    unpackCmd = "dpkg -x $curSrc/ajaretail_*.deb source";

    nativeBuildInputs = [
      dpkg
      patchelf
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share
      mv usr/share/applications $out/share/applications
      mv usr/share/doc $out/share/doc

      mv etc $out/etc

      mv opt $out/opt

      ln -s $out/opt/aja/bin $out/bin

      # For some reason ajanmos doesn't have /opt/aja/lib in its rpath...
      patchelf $out/opt/aja/bin/ajanmos --add-rpath $out/opt/aja/lib

      runHook postInstall
    '';

    dontPatchELF = true;

    inherit meta;
  };
in
buildFHSEnv {
  inherit pname version;

  targetPkgs =
    pkgs:
    [ unwrapped ]
    ++ (with pkgs; [
      ocl-icd
      libGL
      udev
      libpulseaudio
      zstd
      glib
      fontconfig
      freetype
      xorg.libxcb
      xorg.libX11
      xorg.xcbutilwm
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      xorg.libSM
      xorg.libICE
      libxkbcommon
      dbus
      avahi
    ]);

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  unshareIpc = false;
  unsharePid = false;

  runScript = writeShellScript "aja" ''
    exec_binary="$1"
    shift
    export QT_PLUGIN_PATH="${unwrapped}/opt/aja/plugins"
    exec "${unwrapped}/opt/aja/bin/$exec_binary" "$@"
  '';

  extraInstallCommands = ''
    mkdir -p $out/libexec/aja-desktop
    mv $out/bin/${pname} $out/libexec/aja-desktop/${pname}

    for binary in controlpanel controlroom ajanmos systemtest; do
      makeWrapper "$out/libexec/aja-desktop/${pname}" "$out/bin/aja-$binary" \
        --add-flags "$binary"
    done
  '';

  passthru = {
    inherit unwrapped;
  };

  meta = meta // {
    mainProgram = "aja-controlpanel";
  };
}
