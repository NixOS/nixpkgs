{ lib, stdenv, fetchzip
}:

stdenv.mkDerivation rec {
  pname = "widevine-cdm";
  version = "4.10.2449.0";

  src = fetchzip {
    url = "https://dl.google.com/widevine-cdm/${version}-linux-x64.zip";
    sha256 = "sha256-f2kAkP+s3fB+krEZsiujEoI4oznkzSyaIB/CRJZWlXE=";
    stripRoot = false;
  };

  installPhase = ''
    install -vD libwidevinecdm.so $out/libwidevinecdm.so
  '';

  meta = with lib; {
    description = "Widevine CDM";
    homepage = "https://www.widevine.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ jlamur ];
    platforms   = [ "x86_64-linux" ];
  };
}
