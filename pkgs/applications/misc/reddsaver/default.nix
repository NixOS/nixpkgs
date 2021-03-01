{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  version = "0.2.3";
  pname = "reddsaver";

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "reddsaver";
    rev = "v${version}";
    sha256 = "sha256-K6SyfYx8VG0t6yogHwd80AxQuj3TXofHLEqZcDsRs1s=";
  };

  cargoSha256 = "sha256-VDr7fcE13Wy7KoGG3U1GSbWqF5Oad4EobgzOL7dtJDo=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  # package does not contain tests as of v0.2.3
  docCheck = false;

  meta = with lib; {
    description = "CLI tool to download saved images from Reddit";
    homepage = "https://github.com/manojkarthick/reddsaver";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.manojkarthick ];
  };

}
