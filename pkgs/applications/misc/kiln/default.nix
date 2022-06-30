{ lib, buildGoModule, fetchFromSourcehut, scdoc }:

buildGoModule rec {
  pname = "kiln";
  version = "0.3.0";

  src = fetchFromSourcehut {
    owner = "~adnano";
    repo = pname;
    rev = version;
    hash = "sha256-owON9ZNi8BufkeARjC6SwxzM81YJYu+bakhH5quzMrA=";
  };

  nativeBuildInputs = [ scdoc ];

  vendorSha256 = "sha256-C1ueL/zmPzFbpNo5BF56/t74nwCUvb2Vu1exssPqOPE=";

  installPhase = ''
    runHook preInstall
    make PREFIX=$out install
    runHook postInstall
  '';

  meta = with lib; {
    description = "A simple static site generator for Gemini";
    homepage = "https://git.sr.ht/~adnano/kiln";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
