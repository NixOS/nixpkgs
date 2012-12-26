{ stdenv, fetchurl, openssl, curl, coreutils, gawk, bash, which }:

stdenv.mkDerivation {
  name = "esniper-2.27.0";

  src = fetchurl {
    url = "mirror://sourceforge/esniper/esniper-2-27-0.tgz";
    sha256 = "0ca9946395be8958d3eb28c9abc4a1a4d4c9134e4b6b3c3816f4631e3be25c02";
  };

  buildInputs = [openssl curl];

  # Add support for CURL_CA_BUNDLE variable.
  patches = [ ./find-ca-bundle.patch ];

  postInstall = ''
    sed <"frontends/snipe" >"$out/bin/snipe" \
      -e "2i export PATH=\"$out/bin:${coreutils}/bin:${gawk}/bin:${bash}/bin:${which}/bin:\$PATH\""
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
