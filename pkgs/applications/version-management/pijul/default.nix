{ stdenv
, fetchCrate
, rustPlatform
, pkg-config
, libsodium
, openssl
, xxHash
, zstd
, darwin
, gitImportSupport ? true
, libgit2 ? null
}:

rustPlatform.buildRustPackage rec {
  pname = "pijul";
  version = "1.0.0-alpha.17";

  src = fetchCrate {
    inherit version pname;
    sha256 = "03r383fkqx17sb2c0kz71lbn0rdas7nd9yw7ni5fbmrq8rlk9brv";
  };

  cargoSha256 = "0dfmldklklax8nb3pry0h80kih1k1idfjgaxinxkk1iflcm3cwqn";

  cargoBuildFlags = stdenv.lib.optional gitImportSupport "--features=git";

  doCheck = false;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl libsodium xxHash zstd ]
    ++ (stdenv.lib.optionals gitImportSupport [ libgit2 ])
    ++ (stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      CoreServices Security SystemConfiguration
    ]));

  meta = with stdenv.lib; {
    description = "A distributed version control system";
    homepage = "https://pijul.org";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ gal_bolle dywedir ];
  };
}
