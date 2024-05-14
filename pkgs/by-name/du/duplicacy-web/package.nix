{ stdenv, fetchurl, lib }:

let
  version = "1.8.1";
  urls = {
    x86_64-linux = "https://acrosync.com/duplicacy-web/duplicacy_web_linux_x64_${version}";
    aarch64-linux = "https://acrosync.com/duplicacy-web/duplicacy_web_linux_arm64_${version}";
    armv5tel-linux = "https://acrosync.com/duplicacy-web/duplicacy_web_linux_arm_${version}";
  };
  hashes = {
    "x86_64-linux" = "sha256-XgyMlA7rN4YU6bXWP52/9K2LhEigjzgD2xQenGU6dn4=";
    "aarch64-linux" = "sha256-M2RluQKsP1002khAXwWcrTMeBu8sHgV8d9iYRMw3Zbc=";
    "armv5tel-linux" = "sha256-O4CHtKiRTciqKehwCNOJciD8wP40cL95n+Qg/NhVSGQ=";
  };
in

stdenv.mkDerivation {
  pname = "duplicacy-web";
  version = version;

  src = fetchurl {
    url = urls.${stdenv.hostPlatform.system};
    sha256 = hashes.${stdenv.hostPlatform.system};
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/duplicacy-web
    chmod +x $out/bin/duplicacy-web
  '';

  meta = with lib; {
    homepage = "https://duplicacy.com";
    description = "A new generation cloud backup tool with web-based GUI";
    platforms = platforms.linux;
    license = licenses.unfree;
    maintainers = [ maintainers.DogeRam1500 ];
    downloadPage = "https://duplicacy.com/download.html";
  };
}
