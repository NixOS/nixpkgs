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
  version = "1.0.0-alpha.11";

  src = fetchCrate {
    inherit version pname;
    sha256 = "1y2xgbzclmk0i98iydmqgvf6acx0v326dmj9j2hiwrld193fc4dx";
  };

  cargoSha256 = "0i1rr8jg34g4b8i2lvh9gy2rpfa01ma9jpcpyp5zklrzk5f1ksvf";

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
