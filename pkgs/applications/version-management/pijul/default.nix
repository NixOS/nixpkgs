{ stdenv, fetchCrate, rustPlatform, darwin, cargo, pkgconfig, libsodium, openssl }:

with rustPlatform;

buildRustPackage rec {
  name = "pijul-${version}";
  version = "0.10.0";

  src = fetchCrate {
    crateName = "pijul";
    version = version;
    sha256 = "1qmbqk0jnwih97mdshlr89lmvh4crazpysq20xz53nb8ynpwppvy";
    extraPostFetch = ''
      cd $out
      export CARGO_HOME=$(mktemp -d cargo-home.XXX)
      ${cargo}/bin/cargo update
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
