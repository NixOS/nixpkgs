{ stdenv, fetchurl, openssl, libX11, fetchpatch }:

stdenv.mkDerivation (rec {
  pname = "rdesktop";
  version = "1.8.3";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}.tar.gz";
    sha256 = "1r7c1rjmw2xzq8fw0scyb453gy9z19774z1z8ldmzzsfndb03cl8";
  };

  buildInputs = [ openssl libX11 ];

  configureFlags = [
    "--with-ipv6"
    "--with-openssl=${openssl.dev}"
    "--disable-credssp"
    "--disable-smartcard"
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/rdesktop/rdesktop/commit/bd6aa6acddf0ba640a49834807872f4cc0d0a773.patch";
      sha256 = "1siczw870nf2cxqp89y5wdry88b05wwwx2v2i8gsrw5jbc6ar0zs";
    })
    (fetchpatch {
      url = "https://github.com/rdesktop/rdesktop/commit/c6e8e1074b8ac57de6c80c4e3ed38e105b4d94f1.patch";
      sha256 = "1zac8ijmvamgzs0lhkifqvsbyhqzm3pq84blfq1xnz43vx1skwf8";
    })
  ];

  meta = {
    description = "Open source client for Windows Terminal Services";
    homepage = http://www.rdesktop.org/;
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
})
