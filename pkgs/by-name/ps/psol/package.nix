{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "psol";
  version = "1.13.35.2"; # Latest stable, 2018-02-05

  src = fetchurl {
    url = "https://dl.google.com/dl/page-speed/psol/${version}-x64.tar.gz";
    hash = "sha256-3zujyPxU4ThF0KHap6bj2YMSbCORKFG7+Lo1vmRqQ08=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv include lib -t $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "PageSpeed Optimization Libraries";
    homepage = "https://developers.google.com/speed/pagespeed/psol";
    license = licenses.asl20;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    # WARNING: This only works with Linux because the pre-built PSOL binary is only supplied for Linux.
    # TODO: Build PSOL from source to support more platforms.
    platforms = platforms.linux;
  };
}
