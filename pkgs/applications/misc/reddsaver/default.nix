{ lib, stdenv
, fetchFromGitHub
, rustPlatform
, openssl
, pkg-config
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "reddsaver";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "manojkarthick";
    repo = "reddsaver";
    rev = "v${version}";
    sha256 = "0ffci3as50f55n1v36hji4n0b3lkch5ylc75awjz65jz2gd2y2j4";
  };

  cargoSha256 = "1xf26ldgfinzpakcp65w52fdl3arsm053vfnq7gk2fwnq55cjwl0";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isDarwin Security;

  # package does not contain tests as of v0.3.2
  docCheck = false;

  meta = with lib; {
    description = "CLI tool to download saved media from Reddit";
    homepage = "https://github.com/manojkarthick/reddsaver";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = [ maintainers.manojkarthick ];
  };

}
