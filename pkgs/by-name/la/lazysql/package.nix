{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  testers,
  lazysql,
  libx11,
  darwin ? null,
}:

buildGoModule rec {
  pname = "lazysql";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "jorgerojas26";
    repo = "lazysql";
    rev = "v${version}";
    hash = "sha256-0U1iiYOCGxjLWxUaIbX9Yz5l0HAopl0WmOtSpUirynY=";
  };

  vendorHash = "sha256-dhQRURBA8WzA0uweIWcS/x9edClGatbMCcOn55xlF2w=";

  ldflags = [
    "-X main.version=${version}"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libx11 ];

  passthru.tests.version = testers.testVersion {
    package = lazysql;
    command = "lazysql --version";
  };

  meta = {
    description = "Cross-platform TUI database management tool written in Go";
    homepage = "https://github.com/jorgerojas26/lazysql";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "lazysql";
  };
}
