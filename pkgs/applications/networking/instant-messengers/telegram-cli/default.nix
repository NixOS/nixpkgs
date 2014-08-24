{ stdenv, fetchgit, libconfig, lua5_2, openssl, readline, zlib
}:

stdenv.mkDerivation rec {
  name = "telegram-cli";

  src = fetchgit {
    url = "https://github.com/vysheng/tg.git";
    rev = "ac6079a00ac66bb37a3179a82af130b41ec39bc9";
    sha256 = "1rpwnyzmqk7p97n5pd00m5c6rypc39mb3hs94qxxrdcpwpgcb73q";
  };

  buildInputs = [ libconfig lua5_2 openssl readline zlib ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./telegram $out/bin/telegram-wo-key
    cp ./tg.pub $out/
    cat > $out/bin/telegram <<EOF
    #!/usr/bin/env bash
    $out/bin/telegram-wo-key -k $out/tg.pub
    EOF
    chmod +x $out/bin/telegram
  '';

  meta = {
    description = "Command-line interface for Telegram messenger";
    homepage = https://telegram.org/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
