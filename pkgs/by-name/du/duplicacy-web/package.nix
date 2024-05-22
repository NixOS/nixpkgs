{ stdenv, fetchurl, lib }:

let
  inherit (stdenv.hostPlatform) system;

  version = "1.8.1";
  platforms = {
    x86_64-linux = {
      url = "https://acrosync.com/duplicacy-web/duplicacy_web_linux_x64_${version}";
      hash = "sha256-XgyMlA7rN4YU6bXWP52/9K2LhEigjzgD2xQenGU6dn4=";
    };
    aarch64-linux = {
      url = "https://acrosync.com/duplicacy-web/duplicacy_web_linux_arm64_${version}";
      hash = "sha256-M2RluQKsP1002khAXwWcrTMeBu8sHgV8d9iYRMw3Zbc=";
    };
    armv5tel-linux = {
      url = "https://acrosync.com/duplicacy-web/duplicacy_web_linux_arm_${version}";
      hash = "sha256-O4CHtKiRTciqKehwCNOJciD8wP40cL95n+Qg/NhVSGQ=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "duplicacy-web";
  inherit version;

  src = fetchurl (platforms.${system} or throw "Unsupported system: ${system}");
  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/duplicacy-web
    chmod +x $out/bin/duplicacy-web
  '';

  meta =  {
    homepage = "https://duplicacy.com";
    description = "A new generation cloud backup tool with web-based GUI";
    platforms = lib.attrNames platforms;
    license = licenses.unfree;
    maintainers = with lib.maintainers; [ DogeRam1500 ];
    downloadPage = "https://duplicacy.com/download.html";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}


