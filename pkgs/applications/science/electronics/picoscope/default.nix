{ stdenv, lib, fetchurl, dpkg, makeWrapper , mono, gtk-sharp-3_0
, glib, libusb1 , zlib, gtk3-x11, callPackage
, scopes ? [
  "picocv"
  "ps2000"
  "ps2000a"
  "ps3000"
  "ps3000a"
  "ps4000"
  "ps4000a"
  "ps5000"
  "ps5000a"
  "ps6000"
  "ps6000a"
] }:

let
  shared_meta = lib:
    with lib; {
      homepage = "https://www.picotech.com/downloads/linux";
      maintainers = with maintainers; [ expipiplus1 wirew0rm ] ++ teams.lumiguide.members;
      platforms = [ "x86_64-linux" ];
      license = licenses.unfree;
    };

  libpicoipp = callPackage ({ stdenv, lib, fetchurl, autoPatchelfHook, dpkg }:
    stdenv.mkDerivation rec {
      pname = "libpicoipp";
      inherit (sources.libpicoipp) version;
      src = fetchurl { inherit (sources.libpicoipp) url sha256; };
      nativeBuildInputs = [ dpkg autoPatchelfHook ];
      buildInputs = [ stdenv.cc.cc.lib ];
      sourceRoot = ".";
      unpackCmd = "dpkg-deb -x $src .";
      installPhase = ''
        runHook preInstall
        mkdir -p $out/lib
        cp -d opt/picoscope/lib/* $out/lib
        install -Dt $out/usr/share/doc/libpicoipp usr/share/doc/libpicoipp/copyright
        runHook postInstall
      '';
      meta = with lib;
        shared_meta lib // {
          sourceProvenance = with sourceTypes; [ binaryNativeCode ];
          description = "library for picotech oscilloscope software";
        };
    }) { };

  # If we don't have a platform available, put a dummy version here, so at
  # least evaluation succeeds.
  sources =
    (lib.importJSON ./sources.json).${stdenv.system} or { picoscope.version = "unknown"; };

  scopePkg = name:
    { url, version, sha256 }:
    stdenv.mkDerivation rec {
      pname = "lib${name}";
      inherit version;
      src = fetchurl { inherit url sha256; };
      # picoscope does a signature check, so we can't patchelf these
      nativeBuildInputs = [ dpkg ];
      sourceRoot = ".";
      unpackCmd = "dpkg-deb -x $src .";
      installPhase = ''
        runHook preInstall
        mkdir -p $out/lib
        cp -d opt/picoscope/lib/* $out/lib
         runHook postInstall
      '';
      meta = with lib;
        shared_meta lib // {
          description = "library for picotech oscilloscope ${name} series";
        };
    };

  scopePkgs = lib.mapAttrs scopePkg sources;

in stdenv.mkDerivation rec {
  pname = "picoscope";
  inherit (sources.picoscope) version;

  src = fetchurl { inherit (sources.picoscope) url sha256; };

  nativeBuildInputs = [ dpkg makeWrapper ];
  buildInputs = [ gtk-sharp-3_0 mono glib libusb1 zlib ];

  unpackCmd = "dpkg-deb -x $src .";
  sourceRoot = ".";
  scopeLibs = lib.attrVals (map (x: "lib${x}") scopes) scopePkgs;
  MONO_PATH = "${gtk-sharp-3_0}/lib/mono/gtk-sharp-3.0:" + (lib.makeLibraryPath
    ([
      glib
      gtk3-x11
      gtk-sharp-3_0
      libusb1
      zlib
      libpicoipp
    ] ++ scopeLibs));

  installPhase = ''
    runHook preInstall
    mkdir -p $out/
    cp -dr usr/share $out/share
    cp -dr opt/picoscope/* $out/
    makeWrapper "$(command -v mono)" $out/bin/picoscope \
      --add-flags $out/lib/PicoScope.GTK.exe \
      --prefix MONO_PATH : "$MONO_PATH" \
      --prefix LD_LIBRARY_PATH : "$MONO_PATH" \
      --set LANG C
    runHook postInstall
  '';

  # usage:
  # services.udev.packages = [ pkgs.picoscope.rules ];
  # users.groups.pico = {};
  # users.users.you.extraGroups = [ "pico" ];
  passthru.rules = lib.writeTextDir "lib/udev/rules.d/95-pico.rules" ''
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0ce9", MODE="664",GROUP="pico"
  '';

  meta = with lib;
    shared_meta lib // {
      description =
        "Oscilloscope application that works with all PicoScope models";
      longDescription = ''
        PicoScope for Linux is a powerful oscilloscope application that works
        with all PicoScope models. The most important features from PicoScope
        for Windows are included—scope, spectrum analyzer, advanced triggers,
        automated measurements, interactive zoom, persistence modes and signal
        generator control. More features are being added all the time.

        Waveform captures can be saved for off-line analysis, and shared with
        PicoScope for Linux, PicoScope for macOS and PicoScope for Windows
        users, or exported in text, CSV and MathWorks MATLAB 4 formats.
      '';
      sourceProvenance = with sourceTypes; [ binaryBytecode ];
    };
}

