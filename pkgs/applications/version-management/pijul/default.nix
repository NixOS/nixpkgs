{ stdenv, fetchCrate, rustPlatform, darwin, cargo, pkgconfig, libsodium, openssl }:

with rustPlatform;

buildRustPackage rec {
  name = "pijul-${version}";
  version = "0.10.0";

  src = fetchCrate {
    crateName = "pijul";
    version = version;
    sha256 = "0q2hmavsnmmpb1lmq774wdz9yy3m7j2j47l0s2n1715yg7pv42jg";
    extraPostFetch = ''
      cp ${./Cargo.lock} $out/Cargo.lock
    '';
  };

  buildInputs = [
    pkgconfig
    libsodium
    openssl
  ] ++ stdenv.lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ Security ]);

  doCheck = false;

  cargoSha256 = "0axj11qmra087k980agyy3mflans7cqs5jcsy03ygmj0xzin0hjz";

  meta = with stdenv.lib; {
    description = "A distributed version control system";
    homepage = https://pijul.org;
    license = with licenses; [ gpl2Plus ];
    maintainers = [ maintainers.gal_bolle ];
    platforms = platforms.all;
  };
}
