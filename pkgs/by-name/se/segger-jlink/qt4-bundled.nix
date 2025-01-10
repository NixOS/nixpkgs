{
  lib,
  stdenv,
  src,
  version,
  autoPatchelfHook,
  fontconfig,
  xorg,
}:

stdenv.mkDerivation {
  pname = "segger-jlink-qt4";
  inherit src version;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
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
}
