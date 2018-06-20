{ stdenv, fetchFromGitHub, openssl, curl, coreutils, gawk, bash, which }:

stdenv.mkDerivation rec {
  name = "esniper-2.35.0";

  src = fetchFromGitHub {
    owner = "yhfudev";
    repo = "esniper";
    rev = "c95140d376db3c991300a7462e6c172b0ccf3eb5";
    sha256 = "1dfb5hmcrvm3yg9ask362c6s5ylxs21szw23dm737a94br37j890";
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
