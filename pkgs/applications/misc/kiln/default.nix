{ lib, buildGoModule, fetchFromSourcehut, scdoc, installShellFiles }:

buildGoModule rec {
  pname = "kiln";
  version = "0.3.2";

  src = fetchFromSourcehut {
    owner = "~adnano";
    repo = pname;
    rev = version;
    hash = "sha256-PI80td/GV92Msdtive+f+H6FWo7wdaPmPCpwrX3iLlo=";
  };

  nativeBuildInputs = [ scdoc installShellFiles ];

  vendorSha256 = "sha256-C1ueL/zmPzFbpNo5BF56/t74nwCUvb2Vu1exssPqOPE=";

  postInstall = ''
    scdoc < docs/kiln.1.scd > docs/kiln.1
    installManPage docs/kiln.1
  '';

  meta = with lib; {
    description = "A simple static site generator for Gemini";
    homepage = "https://kiln.adnano.co/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
