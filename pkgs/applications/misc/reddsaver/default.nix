{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "reddsaver";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "reddsaver";
    rev = "v${version}";
    sha256 = "07xsrc0w0z7w2w0q44aqnn1ybf9vqry01v3xr96l1xzzc5mkqdzf";
  };

  cargoHash = "sha256-l+fxk9gkM+pStBVJcsN4P2tNCuFIiBaAxpq9SLlvJHk=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  # package does not contain tests as of v0.3.3
  docCheck = false;

  meta = with lib; {
    description = "CLI tool to download saved media from Reddit";
    homepage = "https://github.com/manojkarthick/reddsaver";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.manojkarthick ];
    mainProgram = "reddsaver";
  };

}
