{ lib
, stdenv
, fetchurl
, callPackage
, autoPatchelfHook
, udev
, config
, acceptLicense ? config.segger-jlink.acceptLicense or false
, headless ? false
, makeDesktopItem
, copyDesktopItems
}:

let
  source = import ./source.nix;
  supported = removeAttrs source ["version"];

  platform = supported.${stdenv.system} or (throw "unsupported platform ${stdenv.system}");

  inherit (source) version;

  url = "https://www.segger.com/downloads/jlink/JLink_Linux_V${version}_${platform.name}.tgz";

  src =
    assert !acceptLicense -> throw ''
      Use of the "SEGGER JLink Software and Documentation pack" requires the
      acceptance of the following licenses:

        - SEGGER Downloads Terms of Use [1]
        - SEGGER Software Licensing [2]

      You can express acceptance by setting acceptLicense to true in your
      configuration. Note that this is not a free license so it requires allowing
      unfree licenses as well.

      configuration.nix:
        nixpkgs.config.allowUnfree = true;
        nixpkgs.config.segger-jlink.acceptLicense = true;

      config.nix:
        allowUnfree = true;
        segger-jlink.acceptLicense = true;

      [1]: ${url}
      [2]: https://www.segger.com/purchase/licensing/
    '';
      fetchurl {
        inherit url;
        inherit (platform) hash;
        curlOpts = "--data accept_license_agreement=accepted";
      };

  qt4-bundled = callPackage ./qt4-bundled.nix { inherit src version; };

in stdenv.mkDerivation {
  pname = "segger-jlink";
  inherit src version;

  nativeBuildInputs = [
    autoPatchelfHook
  ] ++ lib.optionals (!headless) [
    copyDesktopItems
  ];

  buildInputs = lib.optionals (!headless) [
    qt4-bundled
  ];

  # Udev is loaded late at runtime
  appendRunpaths = [
    "${udev}/lib"
  ];

  dontConfigure = true;
  dontBuild = true;

  desktopItems = lib.optionals (!headless) (
    map (entry:
      (makeDesktopItem {
        name = entry;
        exec = entry;
        icon = "applications-utilities";
        desktopName = entry;
        genericName = "SEGGER ${entry}";
        categories = [ "Development" ];
        type = "Application";
        terminal = false;
        startupNotify = false;
      })
    ) [
      "JFlash"
      "JFlashLite"
      "JFlashSPI"
      "JLinkConfig"
      "JLinkGDBServer"
      "JLinkLicenseManager"
      "JLinkRTTViewer"
      "JLinkRegistration"
      "JLinkRemoteServer"
      "JLinkSWOViewer"
      "JLinkUSBWebServer"
      "JMem"
    ]
  );

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt

    ${lib.optionalString (!headless) ''
      # Install binaries and runtime files into /opt/
      mv J* ETC GDBServer Firmwares $out/opt

      # Link executables into /bin/
      mkdir -p $out/bin
      for binr in $out/opt/*Exe; do
        binrlink=''${binr#"$out/opt/"}
        ln -s $binr $out/bin/$binrlink
        # Create additional symlinks without "Exe" suffix
        binrlink=''${binrlink/%Exe}
        ln -s $binr $out/bin/$binrlink
      done

      # Copy special alias symlinks
      for slink in $(find $out/opt/. -type l); do
        cp -P -n $slink $out/bin || true
        rm $slink
      done
    ''}

    # Install libraries
    install -Dm444 libjlinkarm.so* -t $out/lib
    for libr in $out/lib/libjlinkarm.*; do
      ln -s $libr $out/opt
    done

    # Install docs and examples
    mkdir -p $out/share
    mv Doc $out/share/docs
    mv Samples $out/share/examples

    # Install udev rules
    install -Dm444 99-jlink.rules -t $out/lib/udev/rules.d/

    runHook postInstall
  '';

  passthru.updateScript = ./update.py;

  meta = with lib; {
    description = "J-Link Software and Documentation pack";
    homepage = "https://www.segger.com/downloads/jlink/#J-LinkSoftwareAndDocumentationPack";
    changelog = "https://www.segger.com/downloads/jlink/ReleaseNotes_JLink.html";
    license = licenses.unfree;
    platforms = attrNames supported;
    maintainers = with maintainers; [
      FlorianFranzen
      h7x4
      stargate01
    ];
  };
}
