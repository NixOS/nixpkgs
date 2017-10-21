{ stdenv, fetchurl, openssl, curl, coreutils, gawk, bash, which }:

stdenv.mkDerivation rec {
  name = "esniper-2.33.0";

  src = fetchurl {
    url    = "mirror://sourceforge/esniper/${stdenv.lib.replaceStrings ["."] ["-"] name}.tgz";
    sha256 = "1pck2x7mp7ip0b21v2sjvq86fz12gzw6kig4vvbrghz5xw5b3f69";
  };

  buildInputs = [ openssl curl ];

  # Add support for CURL_CA_BUNDLE variable.
  # Fix <http://sourceforge.net/p/esniper/bugs/648/>.
  patches = [ ./find-ca-bundle.patch ];

  postInstall = ''
    sed <"frontends/snipe" >"$out/bin/snipe" \
      -e "2i export PATH=\"$out/bin:${stdenv.lib.makeBinPath [ coreutils gawk bash which ]}:\$PATH\""
    chmod 555 "$out/bin/snipe"
  '';

  meta = with stdenv.lib; {
    description = "Simple, lightweight tool for sniping eBay auctions";
    homepage    = http://esniper.sourceforge.net;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 peti ];
    platforms   = platforms.all;
  };
}
