{ stdenv, fetchurl, openssl, curl, coreutils, gawk, bash, which }:

stdenv.mkDerivation {
  name = "esniper-2.28.0";

  src = fetchurl {
    url    = "mirror://sourceforge/esniper/esniper-2-28-0.tgz";
    sha256 = "c2b0ccb757616b32f2d6cf54a4a5e367405fa7bcd6e6ed11835fe4f8a06a016b";
  };

  buildInputs = [ openssl curl ];

  # Add support for CURL_CA_BUNDLE variable.
  # Fix <http://sourceforge.net/p/esniper/bugs/648/>.
  patches = [ ./find-ca-bundle.patch ./fix-ebay-login.patch ];

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
