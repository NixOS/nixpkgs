{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "httprobe";
  version = "0.2";

  src = fetchFromGitHub {
    owner = "tomnomnom";
    repo = "httprobe";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k/Ev+zpYF+DcnQvMbbRzoJ4co83q3pi/D9T4DhtGR/I=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Take a list of domains and probe for working HTTP and HTTPS servers";
    homepage = "https://github.com/tomnomnom/httprobe";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    mainProgram = "httprobe";
  };
})
