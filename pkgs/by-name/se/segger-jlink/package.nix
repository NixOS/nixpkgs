{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, udev
, config
, acceptLicense ? config.segger-jlink.acceptLicense or false
, fontconfig
, xorg
, makeDesktopItem
, copyDesktopItems
}:

let
  supported = {
    x86_64-linux = {
      name = "x86_64";
      hash = "sha256-UsDP+wMS7ZeWMQBObwv5RxbwuWU8nLnHes7LEXK6imE=";
    };
    i686-linux = {
      name = "i386";
      hash = "sha256-InNHXWAc6QZEWyEcTTUCRMDsKd0RtR8d7O0clWKuFo8=";
    };
    aarch64-linux = {
      name = "arm64";
      hash = "sha256-ueIGdqfuIRCuEwaPkgZMgghO9DU11IboLLMryg/mxQ8=";
    };
    armv7l-linux = {
      name = "arm";
      hash = "sha256-6nTQGQpkbqQntheQqiUAdVS4rp30nl2KRUn5Adsfeoo=";
    };
  };

  platform = supported.${stdenv.system} or (throw "unsupported platform ${stdenv.system}");

  version = "796b";

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

  qt4-bundled = stdenv.mkDerivation {
    pname = "segger-jlink-qt4";
    inherit src version;

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    buildInputs = [
      stdenv.cc.cc.lib
      fontconfig
      xorg.libXrandr
      xorg.libXfixes
      xorg.libXcursor
      xorg.libSM
      xorg.libICE
      xorg.libX11
    ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      # Install libraries
      mkdir -p $out/lib
      mv libQt* $out/lib

      runHook postInstall
    '';

    meta = with lib; {
      description = "Bundled QT4 libraries for the J-Link Software and Documentation pack";
      homepage = "https://www.segger.com/downloads/jlink/#J-LinkSoftwareAndDocumentationPack";
      license = licenses.lgpl21;
      maintainers = with maintainers; [ stargate01 ];
      knownVulnerabilities = [
        "This bundled version of Qt 4 has reached its end of life after 2015. See https://github.com/NixOS/nixpkgs/pull/174634"
        "CVE-2023-43114"
        "CVE-2023-38197"
        "CVE-2023-37369"
        "CVE-2023-34410"
        "CVE-2023-32763"
        "CVE-2023-32762"
        "CVE-2023-32573"
        "CVE-2022-25634"
        "CVE-2020-17507"
        "CVE-2020-0570"
        "CVE-2018-21035"
        "CVE-2018-19873"
        "CVE-2018-19871"
        "CVE-2018-19870"
        "CVE-2018-19869"
        "CVE-2015-1290"
        "CVE-2014-0190"
        "CVE-2013-0254"
        "CVE-2012-6093"
        "CVE-2012-5624"
        "CVE-2009-2700"
      ];
    };
  };

in stdenv.mkDerivation {
  pname = "segger-jlink";
  inherit src version;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    qt4-bundled
  ];

  # Udev is loaded late at runtime
  appendRunpaths = [
    "${udev}/lib"
  ];

  dontConfigure = true;
  dontBuild = true;

  desktopItems = map (entry:
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
  ];

  installPhase = ''
    runHook preInstall

    # Install binaries and runtime files into /opt/
    mkdir -p $out/opt
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

  meta = with lib; {
    description = "J-Link Software and Documentation pack";
    homepage = "https://www.segger.com/downloads/jlink/#J-LinkSoftwareAndDocumentationPack";
    license = licenses.unfree;
    platforms = attrNames supported;
    maintainers = with maintainers; [ FlorianFranzen stargate01 ];
  };
}
