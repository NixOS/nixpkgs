{ stdenv, fetchurl, rustPlatform, perl, darwin }:

with rustPlatform;

buildRustPackage rec {
  name = "pijul-${version}";
  version = "0.4.4";

  src = fetchurl {
    url = "https://pijul.org/releases/${name}.tar.gz";
    sha256 = "8f133b7e14bfa84156c103126d53b12c6dfb996dcdebcf1091199ff9c77f3713";
  };

  sourceRoot = "${name}/pijul";

  buildInputs = [ perl ]++ stdenv.lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ Security ]);

  doCheck = false;
  
  depsSha256 = "1zdvnarg182spgydmqwxxr929j44d771zkq7gyh152173i0xqb20";

  meta = with stdenv.lib; {
    description = "A distributed version control system";
    homepage = https://pijul.org;
    license = with licenses; [ gpl2Plus ];
    maintainers = [ maintainers.gal_bolle ];
    platforms = platforms.all;
  };
}
