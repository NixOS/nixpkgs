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

<<<<<<< HEAD
  meta = {
    description = "Take a list of domains and probe for working HTTP and HTTPS servers";
    homepage = "https://github.com/tomnomnom/httprobe";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
=======
  meta = with lib; {
    description = "Take a list of domains and probe for working HTTP and HTTPS servers";
    homepage = "https://github.com/tomnomnom/httprobe";
    license = licenses.mit;
    maintainers = [ ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "httprobe";
  };
}
