{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "kondo";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "tbillington";
    repo = pname;
    rev = "v${version}";
    sha256 = "1rrg0xfm3vn5jh861r4ismrga673g7v6qnzl2v1haflgjhvdazwd";
  };

  cargoSha256 = "1y7g8gw9hsm997d6i99c3dj2gb8y8cgws5001n85f9bpnlvvmf9y";

  meta = with stdenv.lib; {
    description = "Save disk space by cleaning unneeded files from software projects";
    homepage = "https://github.com/tbillington/kondo";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
