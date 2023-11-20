{ lib
, stdenv
, fetchurl
, xar
, cpio
, makeWrapper
}:

let
  pname = "teams";
  versions = {
    darwin = "1.6.00.4464";
  };
  hashes = {
    darwin = "sha256-DvXMrXotKWUqFCb7rZj8wU7mmZJKuTLGyx8qOB/aQtg=";
  };
  meta = with lib; {
    description = "Microsoft Teams";
    homepage = "https://teams.microsoft.com";
    downloadPage = "https://teams.microsoft.com/downloads";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ liff tricktron ];
    platforms = [ "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "teams";
  };

  appName = "Teams.app";

  darwin = stdenv.mkDerivation {
    inherit pname meta;
    version = versions.darwin;

    src = fetchurl {
      url = "https://statics.teams.cdn.office.net/production-osx/${versions.darwin}/Teams_osx.pkg";
      hash = hashes.darwin;
    };

    nativeBuildInputs = [ xar cpio makeWrapper ];

    unpackPhase = ''
      xar -xf $src
      zcat < Teams_osx_app.pkg/Payload | cpio -i
    '';

    sourceRoot = "Microsoft\ Teams.app";
    dontPatch = true;
    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/{Applications/${appName},bin}
      cp -R . $out/Applications/${appName}
      makeWrapper $out/Applications/${appName}/Contents/MacOS/Teams $out/bin/teams
      runHook postInstall
    '';
  };
in
if stdenv.isDarwin
then darwin
else throw "Teams app for Linux has been removed as it is unmaintained by upstream. (2023-09-29)"
