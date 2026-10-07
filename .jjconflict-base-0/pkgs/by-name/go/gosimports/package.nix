{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gosimports";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "rinchsan";
    repo = "gosimports";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xM1CGW8UB+VHN+2Rm6cF/1bOBVDeUG+6kxUxUcvP7FM=";
  };

  vendorHash = "sha256-xR1YTwUcJcpe4NXH8sp9bNAWggvcvVJLztD49gQIdMU=";

  subPackages = [ "cmd/gosimports" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/rinchsan/gosimports";
    description = "Simpler goimports";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ maolonglong ];
    mainProgram = "gosimports";
  };
})
