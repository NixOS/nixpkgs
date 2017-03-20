{ stdenv, fetchurl, rustPlatform, perl, darwin }:

with rustPlatform;

buildRustPackage rec {
  name = "pijul-${version}";
  version = "0.3";

  src = fetchurl {
    url = "https://pijul.org/releases/${name}.tar.gz";
    sha256 = "2c7b354b4ab142ac50a85d70c80949ff864377b37727b862d103d3407e2c7818";
  };

  sourceRoot = "pijul/pijul";

  buildInputs = [ perl ]++ stdenv.lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ Security ]);

  doCheck = false;
  
  depsSha256 = "03bb92mn16d38l49x4p1z21k7gvq3l3ki10brr13p7yv45rwvmzc";

  meta = with stdenv.lib; {
    description = "A distributed version control system";
    homepage = https://pijul.org;
    license = with licenses; [ gpl2Plus ];
    maintainers = [ maintainers.gal_bolle ];
    platforms = platforms.all;
  };
}
