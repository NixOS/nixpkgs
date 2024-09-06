{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, zlib
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "tickrs";
  version = "0.14.10";

  src = fetchFromGitHub {
    owner = "tarkah";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-6iMThVLIkFoNa7Z0MuyhUNGCwFtCfmG7jHvDfrEZE2I=";
  };

  cargoHash = "sha256-gfBmoN91xUcjBafxBoLP41Fl8FuH2taAu3P6sgJPNWI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = with lib; {
    description = "Realtime ticker data in your terminal";
    homepage = "https://github.com/tarkah/tickrs";
    changelog = "https://github.com/tarkah/tickrs/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "tickrs";
  };
}
