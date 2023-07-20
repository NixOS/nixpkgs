{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl, gtk3 }:

rustPlatform.buildRustPackage rec {
  pname = "stremio-service";
  version = "6e987ff";

  src = fetchFromGitHub {
    owner = "Stremio";
    repo = pname;
    rev = "6e987ff193696cca4b0ce78b93e3ca43477a7c37";
    sha256 = "sha256-G3FQhsKmyyOLsNLfzwkFB/xJTwPQGnzVC6KbrXCDtjw=";
  };
  cargoBuildFlags = "--features=offline-build";
  cargoSha256 = "sha256-NX43rF71wq/mFJJrxImUfpbnqRA9/kGb12yAjhHseYo=";
  buildInputs = [ gtk3 openssl ];
  nativeBuildInputs = [ pkg-config ];
  meta = with lib; {
    description = "A companion app for Stremio Web";
    homepage = "https://github.com/Stremio/stremio-service";
    license = licenses.gpl2;
    maintainers = [ ];
  };
}
