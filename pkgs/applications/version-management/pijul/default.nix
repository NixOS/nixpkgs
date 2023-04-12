{ lib, stdenv
, fetchCrate
, rustPlatform
, pkg-config
, libsodium
, openssl
, xxHash
, darwin
, gitImportSupport ? true
, libgit2 ? null
}:

rustPlatform.buildRustPackage rec {
  pname = "pijul";
  version = "1.0.0-beta.4";

  src = fetchCrate {
    inherit version pname;
    sha256 = "sha256-Sx+ZbT1EONWiQmC/5f4thfE9mmTulhTmUWeqPkQgJh8=";
  };

  cargoSha256 = "sha256-vc7rkLCy489W7MjJYiN8vg4DNS65/ZSIEAcw0vaQJtU=";

  doCheck = false;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl libsodium xxHash ]
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
