{ lib, buildGoModule, fetchFromSourcehut, scdoc, installShellFiles }:

buildGoModule rec {
  pname = "kiln";
  version = "0.4.0";

  src = fetchFromSourcehut {
    owner = "~adnano";
    repo = "kiln";
    rev = version;
    hash = "sha256-BMYySYbV4Exl0gCUt+95FnOoIhKM1UO4cw8gCw3Zf9M=";
  };

  nativeBuildInputs = [ scdoc installShellFiles ];

  vendorHash = "sha256-C1ueL/zmPzFbpNo5BF56/t74nwCUvb2Vu1exssPqOPE=";

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
