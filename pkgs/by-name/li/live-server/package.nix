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
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "lomirus";
    repo = "live-server";
    rev = "v${version}";
    hash = "sha256-9NULpK48svCMTx1OeivS+LHVGUGFObg4pBr/V0yIuwM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-f+NePPvuXq20CcKK0pz2MbvWEYQbN29nFc+PmH1pWY4=";

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
