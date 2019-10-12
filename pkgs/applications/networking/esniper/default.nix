{ stdenv, fetchgit, openssl, curl, coreutils, gawk, bash, which }:

stdenv.mkDerivation {
  name = "esniper-2.35.0-18-g4a59da0";

  src = fetchgit {
    url    = "https://git.code.sf.net/p/esniper/git";
    rev    = "4a59da032aa4536b9e5ea95633247650412511db";
    sha256 = "0d3vazh5q7wymqahggbb2apl9hgrm037y4s3j91d24hjgk2pzzyd";
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
