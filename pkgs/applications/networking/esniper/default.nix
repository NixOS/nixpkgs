{ stdenv, fetchurl, openssl, curl }:

stdenv.mkDerivation {
  name = "esniper-2.26.0";

  src = fetchurl {
    url = "mirror://sourceforge/esniper/esniper-2-26-0.tgz";
    sha256 = "5fd9a0f4b27b98deca303cd3d16c1ed060e05a165a40b2f4a9f8546db5e3877d";
  };

  buildInputs = [openssl curl];

  patches = [ ./fix-build-with-latest-curl.patch ];

  postInstall = ''
    sed -e  "2i export PATH=\"$out/bin:\$PATH\"" <"frontends/snipe" >"$out/bin/snipe"
    chmod 555 "$out/bin/snipe"
  '';

  meta = {
    description = "Simple, lightweight tool for sniping eBay auctions";
    homepage = "http://esnipe.rsourceforge.net";
    license = "GPLv2";

    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}


