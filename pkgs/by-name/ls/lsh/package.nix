{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "lsh";
  version = "1.5.4";
  src = fetchFromGitHub {
    owner = "latitudesh";
    repo = "lsh";
    rev = "v${version}";
    sha256 = "sha256-fANid6fWaKE49jh6lUSMZGMdGKy/g9K49pJaKtT6DDc=";
  };
  vendorHash = "sha256-XRhqgyiEBy/aoe9FMihQOkCnr/8Jt2aTKim0u2edZ3w=";
  subPackages = [ "." ];
  meta = {
    changelog = "https://github.com/latitudesh/lsh/releases/tag/v${version}";
    description = "Command-Line Interface for Latitude.sh";
    homepage = "https://github.com/latitudesh/lsh";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dzmitry-lahoda ];
  };
}
