{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "lnd";
  version = "0.8.1-beta";

  src = fetchFromGitHub {
    owner = "lightningnetwork";
    repo = "lnd";
    rev = "v${version}";
    sha256 = "0f9fx2y66l3wxiax2vl2966avamjarkv3vbn9dy0wbxkwg4pfayb";
  };

  modSha256 = "1i6xw2amkg4azvzybcl4pqxif9c0mv8ayrhz9hm8x85bz7i6a787";

  meta = with lib; {
    description = "Lightning Network Daemon";
    homepage = "https://github.com/lightningnetwork/lnd";
    license = lib.licenses.mit;
    maintainers = with maintainers; [ cypherpunk2140 ];
  };
}
