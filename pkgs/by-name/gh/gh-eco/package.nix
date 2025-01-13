{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
let
  version = "0.1.5";
in
buildGoModule {
  pname = "gh-eco";
  inherit version;

  src = fetchFromGitHub {
    owner = "jrnxf";
    repo = "gh-eco";
    rev = "refs/tags/v${version}";
    hash = "sha256-Xtlz+u31hO81M53V0ZUtxmOgJ60zlspgVyCr181QrRE=";
  };

  vendorHash = "sha256-mPZQPjZ+nnsRMYnSWDM9rYeAPvPwAp3vLZXwTNNHSx0=";

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
