{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, segger-jlink
, config
, fontconfig
, xorg
, makeDesktopItem
, copyDesktopItems
}:

let
  supported = {
    x86_64-linux = {
      name = "x86_64";
      sha256 = "d3ec8d54ae0605a40d12d6eeea80967362ed3ed921395f154efee8d65d0c25ee";
    };
    i686-linux = {
      name = "i386";
      sha256 = "2292a6ed6c9b277e514ddbafb396e0e5a8ef8ca57ebd3236cf5ae29a52d2b5bc";
    };
  };

  platform = supported.${stdenv.targetPlatform.system} or (throw "unsupported platform ${stdenv.targetPlatform.system}");

  version = "352a";

  url = "https://www.segger.com/downloads/systemview/SystemView_Linux_V${version}_${platform.name}.tgz";

  src = fetchurl {
    inherit url;
    inherit (platform) sha256;
  };

  qt4-bundled = stdenv.mkDerivation {
    pname = "segger-systemview-qt4";
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
      description = "Bundled QT4 libraries for the SystemView real-time software analysis tool";
      homepage = "https://www.segger.com/products/development-tools/systemview/";
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
  pname = "segger-systemview";
  inherit src version;

  runtimeDependencies = [
    segger-jlink
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    segger-jlink
    qt4-bundled
  ];

  dontConfigure = true;
  dontBuild = true;

  desktopItems = [
    (makeDesktopItem {
      name = "SystemView";
      exec = "SystemView";
      icon = "applications-utilities";
      desktopName = "SystemView";
      genericName = "SEGGER SystemView";
      categories = [ "Development" ];
      type = "Application";
      terminal = false;
      startupNotify = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    # Install binaries
    mkdir -p $out/bin
    install -Dm555 SystemView -t $out/bin
    mv Description $out/bin

    # This library is opened via dlopen at runtime
    for libr in ${segger-jlink}/lib/*; do
      ln -s $libr $out/bin
    done

    # Install docs and examples
    mkdir -p $out/share/docs
    mv Doc/* $out/share/docs
    mkdir -p $out/share/examples
    mv Sample/* $out/share/examples

    runHook postInstall
  '';

  meta = with lib; {
    description = "Real-time software analysis tool from SEGGER";
    homepage = "https://www.segger.com/products/development-tools/systemview/";
    license = licenses.unfree;
    platforms = attrNames supported;
    maintainers = with maintainers; [ stargate01 ];
  };
}
