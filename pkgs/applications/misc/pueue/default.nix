{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "pueue";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Nukesor";
    repo = pname;
    rev = "v${version}";
    sha256 = "1v3fphx71hyv7fq09slhyzchw362swzhmhn7wmbazfdrj6fjhcki";
  };

  cargoSha256 = "04vi9la17pabz1spfw1fzgy4c2ifnis6am5m4ck3lhccnn6j8bd3";

  checkPhase = "cargo test -- --skip test_single_huge_payload";

  meta = with lib; {
    description = "A daemon for managing long running shell commands";
    homepage = "https://github.com/Nukesor/pueue";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
