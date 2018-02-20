{ stdenv, fetchurl, rustPlatform, darwin }:

with rustPlatform;

buildRustPackage rec {
  name = "pijul-${version}";
  version = "0.8.3";

  src = fetchurl {
    url = "https://pijul.org/releases/${name}.tar.gz";
    sha256 = "1xnl22gd9085q9a095z692pfz9zxg26bii5h64vraqlxmsirrvs5";
  };

  preBuild = ''
    cargo update
  '';

  sourceRoot = "${name}/pijul";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ Security ]);

  doCheck = false;

  cargoSha256 = "1h3p1f4v84kdwdjyslmijdxcbf1sdm58hllfssh4875ghws12g40";

  meta = with stdenv.lib; {
    description = "A distributed version control system";
    homepage = https://pijul.org;
    license = with licenses; [ gpl2Plus ];
    maintainers = [ maintainers.gal_bolle ];
    platforms = platforms.all;
  };
}
