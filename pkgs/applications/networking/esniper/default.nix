{ stdenv, fetchurl, openssl, curl }:

let
    name    = "esniper";
in
stdenv.mkDerivation {
  name = "${name}-2.24.0";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}-2-24-0.tgz";
    sha256 = "0h3nlw64x2dczfd4nmz890pk9372iwfzwyyb8zyhiaymb34z5c52";
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


