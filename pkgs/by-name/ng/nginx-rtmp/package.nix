{ lib,
fetchFromGitHub ,
fetchurl,
openssl,
pcre,
zlib,
libxcrypt,
stdenv
}:

stdenv.mkDerivation rec {
  pname = "nginx-rtmp";
  version = "1.21.4";  # Set the desired Nginx version

  src = fetchurl {
    url = "http://nginx.org/download/nginx-${version}.tar.gz";
    sha256 = "1ziv3xargxhxycd5hp6r3r5mww54nvvydiywcpsamg3i9r3jzxyi";
  };

  rtmpModule = fetchFromGitHub {
    owner = "arut";
    repo = "nginx-rtmp-module";
    rev = "refs/tags/v1.2.2";
    sha256 = "sha256-0Gz8Hut7hxP3Tb9/ZTbqMHdts1Cshy3YhH4EMblehXg=";  # Verify and update the sha256
  };

  buildInputs = [ openssl pcre zlib libxcrypt ];

  configureFlags = [
    "--with-http_ssl_module "
    "--add-module=${rtmpModule}"
  ];
  cf = lib.concatStrings configureFlags;

  buildPhase = ''
    ./configure ${cf}
    make
  '';

  installPhase = ''
    make install DESTDIR=$out
  '';

  meta = with lib; {
    description = "NGINX with nginx-rtmp-module";
    homepage = "https://github.com/arut/nginx-rtmp-module";
    license = licenses.bsd2;
    maintainers = with maintainers; [ delirehberi ];
    platforms = platforms.unix;
  };
}

