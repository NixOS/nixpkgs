{ stdenv
, buildGoModule
, fetchFromGitHub
, lib
, git
}:
buildGoModule rec {
  pname = "garble";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "burrowers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-VeqF1MB8knM+NtG9Y+x1g2OF7LFZRC8/c8jicGP3vpo=";
  };

  vendorSha256 = "sha256-FQMeA6VUDQa6wpvMoYsigkzukQ0dArAkysiksJWq+iY=";

  # Used for some of the tests.
  checkInputs = [git];

  preBuild = lib.optionalString (!stdenv.isx86_64) ''
    # The test assumex amd64 assembly
    rm testdata/scripts/asm.txt
  '';

  meta = {
    description = "Obfuscate Go code by wrapping the Go toolchain";
    homepage = "https://github.com/burrowers/garble/";
    maintainers = with lib.maintainers; [ davhau ];
    license = lib.licenses.bsd3;
    broken = stdenv.isDarwin; # never built on Hydra https://hydra.nixos.org/job/nixpkgs/trunk/garble.x86_64-darwin
  };
}
