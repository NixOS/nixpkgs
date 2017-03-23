{ stdenv, fetchurl, rustPlatform, perl, darwin }:

with rustPlatform;

buildRustPackage rec {
  name = "pijul-${version}";
  version = "0.3.3";

  src = fetchurl {
    url = "https://pijul.org/releases/${name}.tar.gz";
    sha256 = "933e68703916ee7b50cd09f928bb072bdfc3388b69ff657578c23080f7df22b8";
  };

  sourceRoot = "${name}/pijul";

  buildInputs = [ perl ]++ stdenv.lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ Security ]);

  doCheck = false;
  
  depsSha256 = "1aiyjl8jbmr8yys5bsd2mg1i7jryzb8kxqlmxp7kjn2qx7b4q2zd";

  meta = with stdenv.lib; {
    description = "A distributed version control system";
    homepage = https://pijul.org;
    license = with licenses; [ gpl2Plus ];
    maintainers = [ maintainers.gal_bolle ];
    platforms = platforms.all;
  };
}
