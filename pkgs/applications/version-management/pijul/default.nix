{ lib, stdenv
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
  version = "1.0.0-alpha.37";

  src = fetchCrate {
    inherit version pname;
    sha256 = "02hdnfpy0hlgwhahrd5ddjmq8r05pyny0r91q3avirli1i7rkvs6";
  };

  cargoSha256 = "16v9nqrfdmrmll72yj6a6wl4rv28n838myjyw2n68kjmijakvnk4";

  cargoBuildFlags = lib.optional gitImportSupport "--features=git";

  doCheck = false;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl libsodium xxHash zstd ]
    ++ (lib.optionals gitImportSupport [ libgit2 ])
    ++ (lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      CoreServices Security SystemConfiguration
    ]));

  meta = with lib; {
    description = "A distributed version control system";
    homepage = "https://pijul.org";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ gal_bolle dywedir ];
  };
}
