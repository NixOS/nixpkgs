{ stdenv, fetchurl, rustPlatform, perl, darwin }:

with rustPlatform;

buildRustPackage rec {
  name = "pijul-${version}";
  version = "0.6.0";

  src = fetchurl {
    url = "https://pijul.org/releases/${name}.tar.gz";
    sha256 = "a6b066b49b25d1083320c5ab23941deee795e1fcbe1faa951e95189fd594cdb3";
  };

  sourceRoot = "pijul";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ Security ]);

  doCheck = false;

  depsSha256 = "0raim0ahqg6fkidb6picfzircdzwdbsdmmv8in70r5hw770bv67r";

  meta = with stdenv.lib; {
    description = "A distributed version control system";
    homepage = https://pijul.org;
    license = with licenses; [ gpl2Plus ];
    maintainers = [ maintainers.gal_bolle ];
    platforms = platforms.all;
  };
}
