{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "httprobe";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "tomnomnom";
    repo = "httprobe";
    rev = "v${version}";
    hash = "sha256-k/Ev+zpYF+DcnQvMbbRzoJ4co83q3pi/D9T4DhtGR/I=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Take a list of domains and probe for working HTTP and HTTPS servers";
    homepage = "https://github.com/tomnomnom/httprobe";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "httprobe";
  };
}
