{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "crlfuzz";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "dwisiswant0";
    repo = "crlfuzz";
    rev = "v${version}";
    sha256 = "sha256-rqhdxOQmZCRtq+IZygKLleb5GoKP2akyEc3rbGcnZmw=";
  };

  vendorHash = "sha256-yLtISEJWIKqCuZtQxReu/Vykw5etqgLpuXqOdtwBkqU=";

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "Tool to scan for CRLF vulnerability";
    mainProgram = "crlfuzz";
    homepage = "https://github.com/dwisiswant0/crlfuzz";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Tool to scan for CRLF vulnerability";
    mainProgram = "crlfuzz";
    homepage = "https://github.com/dwisiswant0/crlfuzz";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
