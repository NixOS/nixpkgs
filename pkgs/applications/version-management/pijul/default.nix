{ stdenv, fetchurl, rustPlatform, perl, darwin }:

with rustPlatform;

buildRustPackage rec {
  name = "pijul-${version}";
  version = "0.4.1";

  src = fetchurl {
    url = "https://pijul.org/releases/${name}.tar.gz";
    sha256 = "e492fde1bea839f474f5b91bb762a0fab5ff6a9bc2b8f20eb91a253ca6feda5a";
  };

  sourceRoot = "${name}/pijul";

  buildInputs = [ perl ]++ stdenv.lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ Security ]);

  doCheck = false;
  
  depsSha256 = "17n66clr31s49gbbcsii0f31s63rncc9mmz4wwdi0yl4r6ykv9h7";

  meta = with stdenv.lib; {
    description = "A distributed version control system";
    homepage = https://pijul.org;
    license = with licenses; [ gpl2Plus ];
    maintainers = [ maintainers.gal_bolle ];
    platforms = platforms.all;
  };
}
