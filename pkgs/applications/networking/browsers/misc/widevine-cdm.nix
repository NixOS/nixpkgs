{ lib
, stdenv
, fetchzip
}:

stdenv.mkDerivation rec {
  pname = "widevine-cdm";
  version = "4.10.2710.0";

  src = fetchzip {
    url = "https://dl.google.com/widevine-cdm/${version}-linux-x64.zip";
    hash = "sha256-lGTrSzUk5FluH1o4E/9atLIabEpco3C3gZw+y6H6LJo=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -vD manifest.json $out/share/google/chrome/WidevineCdm/manifest.json
    install -vD LICENSE.txt $out/share/google/chrome/WidevineCdm/LICENSE.txt
    install -vD libwidevinecdm.so $out/share/google/chrome/WidevineCdm/_platform_specific/linux_x64/libwidevinecdm.so

    runHook postInstall
  '';

  meta = with lib; {
    description = "Widevine CDM";
    homepage = "https://www.widevine.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ jlamur ];
    platforms = [ "x86_64-linux" ];
  };
}
