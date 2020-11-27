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
  version = "1.0.0-alpha.8";

  src = fetchCrate {
    inherit version pname;
    sha256 = "01wag3ckqsa7r6zc7cla428w8hr49n2ybp31s42dqmsbak3xbc14";
  };

  cargoSha256 = "1hh4xmkhbbbkag3v25vh6zpn0r4fmipxmkcr8ahgrxf71dvyxj8x";

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
