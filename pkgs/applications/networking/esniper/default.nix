{ stdenv, fetchgit, openssl, curl, coreutils, gawk, bash, which }:

stdenv.mkDerivation {
  name = "esniper-2.35.0-15-g91d2665";

  src = fetchgit {
    url    = "https://git.code.sf.net/p/esniper/git";
    rev    = "91d2665539beaeac21fb4c0cc2fd39c44e771ed7";
    sha256 = "0dixcsvbcj9jbfjfv50nwvw7w90c4s6gnkrpilaan984i6y45rw0";
  };

  buildInputs = [ openssl curl ];

  # Add support for CURL_CA_BUNDLE variable.
  # Fix <https://sourceforge.net/p/esniper/bugs/648/>.
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
