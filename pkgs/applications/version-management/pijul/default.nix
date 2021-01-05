{ stdenv
, darwin
, fetchCrate
, libsodium
, openssl
, pkg-config
, rustPlatform
, xxHash
, zstd
# Optionals
, gitImportSupport ? true, libgit2 ? null
}:

assert gitImportSupport -> libgit2 != null;

rustPlatform.buildRustPackage rec {
  pname = "pijul";
  version = "1.0.0-alpha.31";

  src = fetchCrate {
    inherit version pname;
    sha256 = "1zj55qpc4fwjx97yq2lilhvxkx0lip5nmb6flcxlzl6d0aa10b3m";
  };

  cargoSha256 = "040m7fid4wq50dmfymvk9250fr3h5j83m90rshzm7qv8gxnkj2az";

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
    maintainers = with maintainers; [ dywedir fabianhjr gal_bolle ];
  };
}
