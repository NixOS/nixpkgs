{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "git-codeowners";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "softprops";
    repo = "git-codeowners";
    rev = "v${version}";
    sha256 = "0bzq4ridzb4l1zqrj1r0vlzkjpgfaqwky5jf49cwjhz4ybwrfpkq";
  };

  cargoSha256 = "1sa70g4jiysmm8jc5a51qh1p03cpvv1yg1j8mj8dnalh0wpywdiw";

  meta = with lib; {
    homepage = "https://github.com/softprops/git-codeowners";
    description = "a git extension to work with CODEOWNERS files";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
