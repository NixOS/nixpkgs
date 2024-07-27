{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  darwin,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "live-server";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "lomirus";
    repo = "live-server";
    rev = "v${version}";
    hash = "sha256-BSAsD9nRlHaTDbBpLBxN9OOQ9SekRwQeYUWV1CZO4oY=";
  };

  cargoHash = "sha256-RwueYpa/CMriSOWwGZhkps6jHmqOdRuz+ECRq/ThPs0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        CoreServices
        SystemConfiguration
      ]
    );

  meta = with lib; {
    description = "Local network server with live reload feature for static pages";
    downloadPage = "https://github.com/lomirus/live-server/releases";
    homepage = "https://github.com/lomirus/live-server";
    license = licenses.mit;
    mainProgram = "live-server";
    maintainers = [ maintainers.philiptaron ];
    platforms = platforms.unix;
  };
}
