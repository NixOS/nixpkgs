{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule rec {
  pname = "joincap";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "assafmo";
    repo = "joincap";
    rev = "refs/tags/v${version}";
    hash = "sha256-HvqtAno26ZSggiXbQpkw5ghxCrmmLb5uDdeSQ2QVeq0=";
  };

  vendorHash = "sha256-pIu/f7hpSUJG5az7sV9tlXJfIjVT37bTV49kTkR80ek=";

  buildInputs = [ libpcap ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Merge multiple pcap files together, gracefully";
    homepage = "https://github.com/assafmo/joincap";
    changelog = "https://github.com/assafmo/joincap/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "joincap";
  };
}
