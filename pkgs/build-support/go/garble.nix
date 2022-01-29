{ stdenv
, buildGoModule
, fetchFromGitHub
, lib
, git
}:
buildGoModule rec {
  pname = "garble";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "burrowers";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F8O/33o//yGnum9sZo1dzcvf3ifRalva6SDC36iPbDA==";
  };

  vendorSha256 = "sha256-iNH/iBEOTkIhVlDGfI66ZYyVjyH6WrLbUSMyONPjUc4=";

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
