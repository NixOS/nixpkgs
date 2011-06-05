{ stdenv, fetchurl, openssl, curl }:

let
  name = "esniper";
in
stdenv.mkDerivation {
  name = "${name}-2.25.0";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-2-25-0.tgz";
    sha256 = "64658eaca2fa27eaec0436a016648b12f6c49d7486cc3a6827f307aa93871def";
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


