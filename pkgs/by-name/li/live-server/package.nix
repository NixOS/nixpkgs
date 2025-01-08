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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "lomirus";
    repo = "live-server";
    rev = "v${version}";
    hash = "sha256-0XZ7ABR2xSVbixXbjdKiUTcQ7TqAZGyVpWqzMx5kR2g=";
  };

  cargoHash = "sha256-lMRj+8D5jigCNXld4QfXy3QpRQo4ecCByqoDGC8no1w=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
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
