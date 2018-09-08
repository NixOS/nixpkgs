{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  name = "git-codeowners-${version}";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "softprops";
    repo = "git-codeowners";
    rev = "v${version}";
    sha256 = "0bzq4ridzb4l1zqrj1r0vlzkjpgfaqwky5jf49cwjhz4ybwrfpkq";
  };

  cargoSha256 = "0rdmv9s86xba1zkl2j5rgix6k7pkkxqmpar03sak2fjrd7mh8iz0";

  meta = with lib; {
    homepage = https://github.com/softprops/git-codeowners;
    description = "a git extension to work with CODEOWNERS files";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
