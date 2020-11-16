{ stdenv
, fetchCrate
, rustPlatform
, pkg-config
, clang
, libclang
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
  version = "1.0.0-alpha.3";

  src = fetchCrate {
    inherit version pname;
    sha256 = "0bz38vvzjrplb2mgcypg2p4kq33v6m58yivg15s2ghr7ly9k5ybx";
  };

  cargoSha256 = "0p9djvdjzyjzsn3fyw6f74fix39s3y92246cgzcqhc1qlwwz67rl";

  cargoBuildFlags = stdenv.lib.optional gitImportSupport "--features=git";
  LIBCLANG_PATH = "${libclang}/lib";

  doCheck = false;
  nativeBuildInputs = [ pkg-config clang ];
  buildInputs = [ openssl libclang libsodium xxHash zstd ]
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
