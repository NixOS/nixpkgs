{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
let
  version = "0.1.8";
in
buildGoModule {
  pname = "gh-eco";
  inherit version;

  src = fetchFromGitHub {
    owner = "jrnxf";
    repo = "gh-eco";
    tag = "v${version}";
    hash = "sha256-DFidh2IWT5pvrsxp1sm59KB+Xunm6KhdYoMGJsM0gQw=";
  };

  vendorHash = "sha256-WuAV6g/UVaCexRzWxNuJwFntQA0Vexp8D/Z+DcNLbZE=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = {
    homepage = "https://github.com/coloradocolby/gh-eco";
    description = "gh extension to explore the ecosystem";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ helium ];
    mainProgram = "gh-eco";
  };
}
