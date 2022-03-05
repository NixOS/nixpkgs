{ lib, stdenv, fetchurl
, unzip
}:

stdenv.mkDerivation rec {
  pname = "widevine";
  version = "4.10.2391.0";

  src = fetchurl {
    url = "https://dl.google.com/widevine-cdm/${version}-linux-x64.zip";
    sha256 = "sha256-7gH808C67m/s09e4rQUQHb/t+iGVdzW+YzrB1ZxGIdo=";
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    install -vD manifest.json $out/share/google/chrome/WidevineCdm/manifest.json
    install -vD LICENSE.txt $out/share/google/chrome/WidevineCdm/LICENSE.txt
    install -vD libwidevinecdm.so $out/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so
  '';

  meta = with lib; {
    description = "Widevine support for Vivaldi";
    homepage = "https://www.widevine.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ betaboon ];
    platforms   = [ "x86_64-linux" ];
  };
}
