{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "reddsaver";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "reddsaver";
    rev = "v${version}";
    sha256 = "0kww3abgvxr7azr7yb8aiw28fz13qb4sn3x7nnz1ihmd4yczi9fg";
  };

  cargoSha256 = "09xm22vgmd3dc0wr6n3jczxvhwpcsijwfbv50dz1lnsx57g8mgmd";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  # package does not contain tests as of v0.3.1
  docCheck = false;

  meta = with lib; {
    description = "CLI tool to download saved media from Reddit";
    homepage = "https://github.com/manojkarthick/reddsaver";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.manojkarthick ];
  };

}
