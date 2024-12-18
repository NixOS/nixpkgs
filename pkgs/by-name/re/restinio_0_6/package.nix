{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "restinio";
  version = "0.6.19";

  src = fetchurl {
    url = "https://github.com/Stiffstream/restinio/releases/download/v.${version}/${pname}-${version}.tar.bz2";
    hash = "sha256-fyHuvrlm4XDWq1TpsZiskn1DkJASFzngN8D6O7NnskA=";
  };

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/include
    mv restinio-*/dev/restinio $out/include

    runHook postInstall
  '';

  meta = with lib; {
    description = "Cross-platform, efficient, customizable, and robust asynchronous HTTP/WebSocket server C++14 library";
    homepage = "https://github.com/Stiffstream/restinio";
    changelog = "https://github.com/Stiffstream/restinio/releases/tag/v.${version}";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
