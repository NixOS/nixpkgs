{
  lib,
  stdenv,
  fetchurl,
  curl,
  unzip,
  ncurses5,
  dmidecode,
  coreutils,
  util-linux,
  autoPatchelfHook,
  makeWrapper,
}:
let
  sources = {
    "x86_64-linux" = {
      url = "https://web.archive.org/web/20231205092714/https://www.passmark.com/downloads/pt_linux_x64.zip";
      hash = "sha256-q9H+/V4fkSwJJEp+Vs+MPvndi5DInx5MQCzAv965IJg=";
    };
    "aarch64-linux" = {
      url = "https://web.archive.org/web/20231205092807/https://www.passmark.com/downloads/pt_linux_arm64.zip";
      hash = "sha256-7fmd2fukJ56e0BJFJe3SitGlordyIFbNjIzQv+u6Zuw=";
    };
  };
in
stdenv.mkDerivation rec {
  version = "11.0.1002";
  pname = "passmark-performancetest";

  src = fetchurl (
    sources.${stdenv.system} or (throw "Unsupported system for PassMark performance test")
  );

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
    curl
    ncurses5
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 pt_linux_* "$out/bin/performancetest"
    runHook postInstall
  '';

  # Prefix since program will call sudo
  postFixup = ''
    wrapProgram $out/bin/performancetest \
        --prefix PATH ":" ${
          lib.makeBinPath [
            dmidecode
            coreutils
            util-linux
          ]
        }
  '';

  meta = with lib; {
    description = "Software tool that allows everybody to quickly assess the performance of their computer and compare it to a number of standard 'baseline' computer systems";
    homepage = "https://www.passmark.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ neverbehave ];
    platforms = builtins.attrNames sources;
    mainProgram = "performancetest";
  };
}
