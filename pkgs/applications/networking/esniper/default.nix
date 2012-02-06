{ stdenv, fetchurl, openssl, curl }:

stdenv.mkDerivation {
  name = "esniper-2.27.0";

  src = fetchurl {
    url = "mirror://sourceforge/esniper/esniper-2-27-0.tgz";
    sha256 = "0ca9946395be8958d3eb28c9abc4a1a4d4c9134e4b6b3c3816f4631e3be25c02";
  };

  buildInputs = [openssl curl];

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


