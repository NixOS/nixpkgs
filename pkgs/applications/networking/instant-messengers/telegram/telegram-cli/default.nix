{ stdenv, libevent, openssl, libgcrypt, zlib, readline, libconfig, lua, jansson, fetchgit }:
stdenv.mkDerivation rec {
  pname = "telegram-cli";
  version = "2016-03-23";
  src = fetchgit {
    url = "https://github.com/vysheng/tg.git";
    rev = "6547c0b21b977b327b3c5e8142963f4bc246187a";
    sha256 = "1d4p6wkzdbp1p8wcj44cknhwddwkgd3px0ds7x0q19p0c0067y8m";
    deepClone = true;
  };
  buildInputs = [
                  libevent
                  openssl
                  libgcrypt
                  zlib
                  readline
                  libconfig
                  lua
                  jansson
                ];

  installPhase =
  ''
    mkdir -p $out
    cp -R bin $out
  '';

  CFLAGS="-Wno-cast-function-type";
  configureFlags = [ "--disable-openssl" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/vysheng/tg";
    description = "Command-line interface for Telegram. Uses readline interface.";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
