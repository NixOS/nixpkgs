{ stdenv, fetchurl, rustPlatform, darwin }:

with rustPlatform;

buildRustPackage rec {
  name = "pijul-${version}";
  version = "0.7.3";

  src = fetchurl {
    url = "https://pijul.org/releases/${name}.tar.gz";
    sha256 = "08cffv6nfp1iv9m2qhr9hggy9kg8xp07p8kqkjypfsdsb983vz5n";
  };

  sourceRoot = "${name}/pijul";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ Security ]);

  doCheck = false;

  depsSha256 = "1qzzpnkyw1bn5fnj06c80f7985v1q0rqcphrrrkpbi33lg5mzgbv";

  meta = with stdenv.lib; {
    description = "A distributed version control system";
    homepage = https://pijul.org;
    license = with licenses; [ gpl2Plus ];
    maintainers = [ maintainers.gal_bolle ];
    platforms = platforms.all;
  };
}
