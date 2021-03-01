{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ox";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "curlpipe";
    repo = pname;
    rev = version;
    sha256 = "18iffnmvax6mbnhypf7yma98y5q2zlsyp9q18f92fdwz426r33p0";
  };

  cargoSha256 = "0v0a1dl9rq5qyy9xwnb59w62qr9db3y3zlmnp60wafvj70zi9zxs";

  meta = with lib; {
    description = "An independent Rust text editor that runs in your terminal";
    homepage = "https://github.com/curlpipe/ox";
    changelog = "https://github.com/curlpipe/ox/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
