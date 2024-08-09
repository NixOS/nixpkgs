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
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "convco";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-S5k0d29tuR0VkJrqCiWg1v+W2n9TrQCfMOInII4jxg0=";
  };

  cargoHash = "sha256-cYb3syf+k4V0pCpekQ2tY73Gl6rDc9YMCXs3TKRtgpo=";

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ openssl ] ++ lib.optionals stdenv.isDarwin [ libiconv darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "Conventional commit cli";
    mainProgram = "convco";
    homepage = "https://github.com/convco/convco";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ hoverbear cafkafk ];
  };
}
