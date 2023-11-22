{ lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "secure-delete";
  version = "3.1";
  src = fetchurl {
    url =
      "https://github.com/hackerschoice/THC-Archive/raw/96eeadb00075097c68bc2c6d10b0a7fbd5be8fae/Tools/secure_delete-${version}.tar.gz";
    sha256 = "1mgqvmxwy36rxjzgd1m0k0qjc7xwjs2nwc5v7gqvvwg3vk8ldn59";
  };

  patches = [
    (fetchurl {
      url =
        "https://build.opensuse.org/public/source/security/secure-delete/secure-delete_3.1-5.diff?rev=4";
      sha256 = "1ajs87lnqd3gvyj3bs9rvrsd1aa4vm01x5187mgcc5xp08l967a7";
    })
  ];
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1

    install -m 755 sfill smem sswap srm $out/bin
    install -m 644 sfill.1 smem.1 sswap.1 srm.1 $out/share/man/man1
  '';
  meta = {
    homepage = "https://www.thc.org";
    description = "Secure file deletion utilities";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dettlaff ];
  };
}
