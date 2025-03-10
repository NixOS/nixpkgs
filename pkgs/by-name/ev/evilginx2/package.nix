{
  stdenv,
  fetchzip,
  unzip,
  lib,
}:
stdenv.mkDerivation {
  pname = "evilginx2";
  version = "3.3.0";

  src = fetchzip {
    url = "https://github.com/kgretzky/evilginx2/releases/download/v3.3.0/evilginx-v3.3.0-linux-64bit.zip";
    sha256 = "sha256-PXWROzd0Ow3tl0+jHD1PozpN6mbD2lskCTAIQyd50qQ=";
    stripRoot = false;
  };
  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/bin
  '';
  meta = with lib; {
    description = "a man-in-the-middle attack framework used for phishing login credentials along with session cookies";
    longDescription = ''
      **Evilginx** is a man-in-the-middle attack framework used for phishing login credentials along with session cookies, which in turn allows to bypass 2-factor authentication protection.

      This tool is a successor to [Evilginx](https://github.com/kgretzky/evilginx), released in 2017, which used a custom version of nginx HTTP server to provide man-in-the-middle functionality to act as a proxy between a browser and phished website.
      Present version is fully written in GO as a standalone application, which implements its own HTTP and DNS server, making it extremely easy to set up and use.
    '';
    homepage = "https://github.com/kgretzky/evilginx2";
    license = licenses.bsd3;
    mainProgram = "evilginx2";
    platforms = with lib.platforms; [ "x86_64-linux" ];
  };
}
