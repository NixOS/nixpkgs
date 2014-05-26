{ stdenv, fetchurl, openssl, curl, coreutils, gawk, bash, which }:

stdenv.mkDerivation {
  name = "esniper-2.30.0";

  src = fetchurl {
    url    = "mirror://sourceforge/esniper/esniper-2-30-0.tgz";
    sha256 = "1p85d5qfr3f35xfj5555ck4wwk5hqkh65ivam1527p8dwcz00wpl";
  };

  buildInputs = [ openssl curl ];

  # Add support for CURL_CA_BUNDLE variable.
  # Fix <http://sourceforge.net/p/esniper/bugs/648/>.
  patches = [ ./find-ca-bundle.patch ];

  postInstall = ''
    sed <"frontends/snipe" >"$out/bin/snipe" \
      -e "2i export PATH=\"$out/bin:${coreutils}/bin:${gawk}/bin:${bash}/bin:${which}/bin:\$PATH\""
    chmod 555 "$out/bin/snipe"
  '';

  meta = with stdenv.lib; {
    description = "Simple, lightweight tool for sniping eBay auctions";
    homepage    = http://esnipe.rsourceforge.net;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 simons ];
    platforms   = platforms.all;
  };
}
