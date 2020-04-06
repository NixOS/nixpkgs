{ stdenv, fetchgit, openssl, curl, coreutils, gawk, bash, which }:

stdenv.mkDerivation {
  name = "esniper-2.35.0-21-g6379846";

  src = fetchgit {
    url    = "https://git.code.sf.net/p/esniper/git";
    rev    = "637984623984ef36782d52d8968df7fae7bbb0a7";
    sha256 = "1md3fzs0k88f6mgvrj1yrh96mn0qlca2p6vfqj6dnpyb8pjjwp8w";
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
