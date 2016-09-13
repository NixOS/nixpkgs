{ stdenv, fetchurl }:
let
  version = "2.0.63547.0830";
in stdenv.mkDerivation {
  name = "zoom_us-${version}";
  src = fetchurl {
    url = "https://zoom.us/client/${version}/zoom_x86_64.tar.xz";
    sha256 = "1c843z99sv1blnhrhi78n8djk590zp89a19rjhkmyhpqrgj0x02x";
  };

  installPhase = ''
    mkdir -p "$out"/{opt,bin}
    cp -ra * "$out/opt"
    ln -s "$out/opt/ZoomLauncher" "$out/bin/ZoomLauncher"
    ln -s ZoomLauncher "$out/bin/zoom"
  '';

  meta = with stdenv.lib; {
    description = "Video Conferencing and Web Conferencing Service";
    license = licenses.unfree;
    homepage = "http://zoom.us";
    platforms = platforms.x86_64;
  };
}
