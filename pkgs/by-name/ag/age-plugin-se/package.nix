{ lib
, stdenv
, fetchzip
}:

stdenv.mkDerivation rec {
  pname = "age-plugin-se";
  version = "0.0.5";

  src = fetchzip {
    url = "https://github.com/remko/age-plugin-se/releases/download/v${version}/age-plugin-se-v${version}-macos.zip";
    hash = "sha256-hYJu2jhiQtic81nn3GGO8yQUAFwF80xQE+z4eZ75J74=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp age-plugin-se $out/bin/age-plugin-se
  '';

  meta = with lib; {
    description = "Age plugin for Apple's Secure Enclave";
    homepage = "https://github.com/remko/age-plugin-se";
    maintainers = with maintainers; [ elohmeier ];
    platforms = platforms.darwin;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
