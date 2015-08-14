{ stdenv, fetchgit, libconfig, lua5_2, openssl, readline, zlib
, libevent, pkgconfig, python, jansson, bash
}:

stdenv.mkDerivation rec {
  name = "telegram-cli-2015-07-30";

  src = fetchgit {
    url = "https://github.com/vysheng/tg.git";
    sha256 = "0phn9nl0sf2fylzfwi427xq60cfrnpsvhh8bp55y1wcjkmp0fxsn";
    rev = "2052f4b381337d75e783facdbfad56b04dec1a9c";
  };

  buildInputs = [ libconfig lua5_2 openssl readline zlib libevent pkgconfig python jansson ];
  installPhase = ''
    mkdir -p $out/bin
    cp ./bin/telegram-cli $out/bin/telegram-wo-key
    cp ./tg-server.pub $out/
    cat > $out/bin/telegram-cli <<EOF
    #!${bash}/bin/sh
    $out/bin/telegram-wo-key -k $out/tg-server.pub
    EOF
    chmod +x $out/bin/telegram-cli
  '';

  meta = {
    description = "Command-line interface for Telegram messenger";
    homepage = https://telegram.org/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.jagajaga ];
  };
}
