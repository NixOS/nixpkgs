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
  version = "1.0.0-alpha.35";

  src = fetchCrate {
    inherit version pname;
    sha256 = "02x4v63shlbnyppwm10qv8smbfz6a8kpwr3rcvzwpa0blqx2sq4n";
  };

  cargoSha256 = "1hmj9470x1ynj5phxsyi0gakzmxbmgb5y51xarrks34f9z7a655v";

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
