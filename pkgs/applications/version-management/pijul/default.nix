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
  version = "1.0.0-alpha";

  src = fetchCrate {
    inherit version pname;
    sha256 = "0dnw2cxsxb20my81szyqjsmmnkakxawvsk6cnd1fi88k4lr0z2xh";
  };

  cargoSha256 = "130vryqs0g4a0328ivqafdylwqs64g4mp8vgmz6nz4c9l3h9wgcx";

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
