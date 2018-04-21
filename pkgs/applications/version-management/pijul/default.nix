{ stdenv, fetchurl, rustPlatform, darwin, pkgconfig, openssl, libsodium }:

with rustPlatform;

buildRustPackage rec {
  name = "pijul-${version}";
  version = "0.10.0";

  src = fetchurl {
    url = "https://pijul.org/releases/${name}.tar.gz";
    sha256 = "1lkipcp83rfsj9yqddvb46dmqdf2ch9njwvjv8f3g91rmfjcngys";
  };

  preBuild = ''
    cargo update
  '';

  buildInputs = [ pkgconfig openssl libsodium ] ++
    stdenv.lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ Security ]);

  doCheck = false;

  cargoSha256 = "03j82kbx1mh7pcacz5dk7x29xz0rajvx9y68mrjgixb4xwqiqrz5";

  meta = with stdenv.lib; {
    description = "A distributed version control system";
    homepage = https://pijul.org;
    license = with licenses; [ gpl2Plus ];
    maintainers = [ maintainers.gal_bolle ];
    platforms = platforms.all;
  };
}
