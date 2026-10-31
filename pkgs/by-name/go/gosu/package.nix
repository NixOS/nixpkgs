{
  lib,
  buildGoModule,
  fetchFromGitHub,
  testers,
  gosu,
}:

buildGoModule (finalAttrs: {
  pname = "gosu";
  version = "1.20";

  src = fetchFromGitHub {
    owner = "tianon";
    repo = "gosu";
    rev = finalAttrs.version;
    hash = "sha256-uF7ZxW56NqFbTizXrttXT+l6yq+6ptSc1csYDNu1Gnw=";
  };

  vendorHash = "sha256-wu5xczAvRH3CqsE+1+0w4aoxrM5RYm/yZSeXilKH1Jc=";

  ldflags = [
    "-d"
    "-s"
    "-w"
  ];

  passthru.tests.version = testers.testVersion {
    package = gosu;
  };

  meta = {
    description = "Tool that avoids TTY and signal-forwarding behavior of sudo and su";
    mainProgram = "gosu";
    homepage = "https://github.com/tianon/gosu";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
