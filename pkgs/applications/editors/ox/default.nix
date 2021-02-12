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

  cargoSha256 = "1s444vcch8rvj3pkh60gmyx5p42086ls6rmyygng33nsgvzi42cy";

  meta = with lib; {
    description = "An independent Rust text editor that runs in your terminal";
    homepage = "https://github.com/curlpipe/ox";
    changelog = "https://github.com/curlpipe/ox/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ fortuneteller2k ];
  };
}
