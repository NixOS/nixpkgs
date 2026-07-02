{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "crlfuzz";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "dwisiswant0";
    repo = "crlfuzz";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-rqhdxOQmZCRtq+IZygKLleb5GoKP2akyEc3rbGcnZmw=";
  };

  vendorHash = "sha256-yLtISEJWIKqCuZtQxReu/Vykw5etqgLpuXqOdtwBkqU=";

  doCheck = true;

  meta = {
    description = "Tool to scan for CRLF vulnerability";
    mainProgram = "crlfuzz";
    homepage = "https://github.com/dwisiswant0/crlfuzz";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
