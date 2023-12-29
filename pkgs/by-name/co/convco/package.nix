{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, cmake
, libiconv
, openssl
, pkg-config
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "convco";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "convco";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qf04mtxBqZy9kpFsqz8lVtyUzNtCYE8cNiVJVQ+sCn0=";
  };

  cargoHash = "sha256-A1z8ccdsaBC9gY4rD/0NnuQHm7x4eVlMPBvkMKGHK54=";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "A Conventional commit cli";
    homepage = "https://github.com/convco/convco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ hoverbear cafkafk ];
  };
}
