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
  version = "1.0.0-alpha.21";

  src = fetchCrate {
    inherit version pname;
    sha256 = "0csa2a8ci6b9vgq57hyz2ng0x8pv1p1ilw72z2b8rrpacdrzb633";
  };

  cargoSha256 = "05z5iqs63s6cvaq4sjfxhcg5ka3rwn6ikcjs26jyqcbkp2bd9z88";

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
