{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  name = "git-codeowners-${version}";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "softprops";
    repo = "git-codeowners";
    rev = "v${version}";
    sha256 = "0imxbi6y1165bi2rik0n98v79fkgp8alb615qh41idg1p2krzyy5";
  };

  cargoSha256 = "0h831rf5vlvpzfm4sr3fvwlc0ys776fqis90y414mczphkxvz437";

  meta = with lib; {
    homepage = "https://github.com/softprops/git-codeowners";
    description = "a git extension to work with CODEOWNERS files";
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
  };
}
