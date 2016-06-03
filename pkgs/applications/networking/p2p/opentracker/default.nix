{ stdenv, fetchgit, libowfat, zlib }:

stdenv.mkDerivation {
  name = "opentracker-2014-08-03";
  src = fetchgit {
    url = "https://github.com/masroore/opentracker.git";
    rev = "9a26b3d203755577879315ecc2b515d0e22793cb";
    sha256 = "1ayj3j9jv6h26jfhw93wcw7lvhwyfnc20kkicvskalwzw51mpsz8";
  };
  
  buildInputs = [ libowfat zlib ];
  
  installPhase = ''
    mkdir -p $out/bin
    cp opentracker $out/bin
  '';
  
  meta = with stdenv.lib; {
    homepage = https://github.com/masroore/opentracker;
    license = "beer-ware";
    platforms = platforms.linux;
    description = "Bittorrent tracker project aiminf for minimal resource usage and is intended to run at your wlan router";
  };
}
