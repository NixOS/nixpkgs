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
  version = "1.0.0-beta";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-s7fHg6Le4y0yAyxOQf6iUUHA4dYsamlTUb0KISOHI7Q=";
  };

  cargoSha256 = "sha256-09PWy1yfr1FY2AsKaoZZswi4P5JdNcumIOmTm+M21UE=";

  doCheck = false;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl libsodium xxHash zstd ]
    ++ (lib.optionals gitImportSupport [ libgit2 ])
    ++ (lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      CoreServices Security SystemConfiguration
    ]));

  buildFeatures = lib.optional gitImportSupport "git";

  meta = with lib; {
    description = "A distributed version control system";
    homepage = "https://pijul.org";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ gal_bolle dywedir fabianhjr ];
  };
}
