{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  ghr,
}:

buildGoModule rec {
  pname = "ghr";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "tcnksm";
    repo = "ghr";
    rev = "v${version}";
    sha256 = "sha256-Is0D8tElv86s++NV6upu8RXvce65uPWQGIOl0Ftxf/M=";
  };

  vendorHash = "sha256-gVDZgV7EF4LrCDX25tGpECecLi8IgstpzCOGfJ5+rhA=";

  # Tests require a Github API token, and networking
  doCheck = false;
  doInstallCheck = true;

  passthru.tests.version = testers.testVersion {
    package = ghr;
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/tcnksm/ghr";
    description = "Upload multiple artifacts to GitHub Release in parallel";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "ghr";
  };
}
