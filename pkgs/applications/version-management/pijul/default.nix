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
  version = "1.0.0-alpha.1";

  src = fetchCrate {
    inherit version pname;
    sha256 = "113j7f6l9yvgm3x65p268940hk2svspg0n63lg0dpp8hakk3mslq";
  };

  cargoSha256 = "0lciyhh4yv2z9aii0xph8sird4f9624pk9hynx7441hwjjdmgy59";

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
