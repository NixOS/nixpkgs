{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, pkg-config
, openssl
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "oha";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-5HEPnAPamR6F4GbQR0Xib+tUZuNU6xe8XQ6ugYw8RyU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-C85D9rqjA3ubbktum2Z9uYzairi1hJnJ7aaBWy7oz1c=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # tests don't work inside the sandbox
  doCheck = false;

  meta = with lib; {
    description = "HTTP load generator inspired by rakyll/hey with tui animation";
    homepage = "https://github.com/hatoo/oha";
    changelog = "https://github.com/hatoo/oha/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "oha";
  };
}
