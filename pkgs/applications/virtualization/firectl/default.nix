{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "firectl";
  # The latest upstream 0.1.0 is incompatible with firecracker
  # v0.1.0. See issue: https://github.com/firecracker-microvm/firectl/issues/82
  version = "unstable-2022-03-01";

  src = fetchFromGitHub {
    owner = "firecracker-microvm";
    repo = pname;
    rev = "9f1b639a446e8d75f31787a00b9f273c1e68f12c";
    sha256 = "TjzzHY9VYPpWoPt6nHYUerKX94O03sm524wGM9lGzno=";
  };

  vendorSha256 = "3SVEvvGNx6ienyJZg0EOofHNHCPSpJUGXwHxokdRG1c=";

  doCheck = false;

  meta = with lib; {
    description = "A command-line tool to run Firecracker microVMs";
    homepage = "https://github.com/firecracker-microvm/firectl";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ xrelkd ];
  };
}
