{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "credential-detector";
  version = "1.14.6";

  src = fetchFromGitHub {
    owner = "ynori7";
    repo = "credential-detector";
    rev = "v${finalAttrs.version}";
    hash = "sha256-15v+2rBEC7/bwDt+HKnQmObsqyFkLSdCZSpGN2nfius=";
  };

  vendorHash = "sha256-U6/xFRi0Xr8sVhhokmkBLCd7zqe+4A9rhNTNG/XIjSw=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Tool to detect potentially hard-coded credentials";
    mainProgram = "credential-detector";
    homepage = "https://github.com/ynori7/credential-detector";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
