{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mixtool";
  version = "0-unstable-2025-07-07";

  src = fetchFromGitHub {
    owner = "monitoring-mixins";
    repo = "mixtool";
    rev = "1abe34c3187d53b795d0474535b476bc9b7500c3";
    hash = "sha256-RRoz5Kp/IGkUD6XVK70+k4L05rYqhkqh6LpopihyEd8=";
  };

  vendorHash = "sha256-o9HNcq7XHXH/s6UthYADsktGh9NjgC1rVPbGP11Cfc0=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  meta = {
    description = "Helper for easily working with jsonnet mixins";
    homepage = "https://github.com/monitoring-mixins/mixtool";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arikgrahl ];
    mainProgram = "mixtool";
  };
})
