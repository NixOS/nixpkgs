{ stdenv, fetchurl, rustPlatform, darwin, libsodium, openssl, pkgconfig }:

with rustPlatform;

buildRustPackage rec {
  name = "pijul-${version}";
  version = "0.10.0";

  src = fetchurl {
    url = "https://pijul.org/releases/${name}.tar.gz";
    sha256 = "1lkipcp83rfsj9yqddvb46dmqdf2ch9njwvjv8f3g91rmfjcngys";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ libsodium openssl ] ++
    stdenv.lib.optionals stdenv.isDarwin
      (with darwin.apple_sdk.frameworks; [ Security ]);

  doCheck = false;

  cargoSha256 = "1419mlxa4p53hm5qzfd1yi2k0n1bcv8kaslls1nyx661vknhfamw";

  meta = with stdenv.lib; {
    description = "A distributed version control system";
    homepage = https://pijul.org;
    license = with licenses; [ gpl2Plus ];
    maintainers = [ maintainers.gal_bolle ];
    platforms = platforms.all;
  };
}
