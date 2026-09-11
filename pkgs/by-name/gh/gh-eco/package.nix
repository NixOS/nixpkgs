{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:
let
  version = "0.1.6";
in
buildGoModule {
  pname = "gh-eco";
  inherit version;

  src = fetchFromGitHub {
    owner = "jrnxf";
    repo = "gh-eco";
    tag = "v${version}";
    hash = "sha256-PkZ/5mYAbPAELxW4l4BIck4qedOJ7htWqrH0KEKrF9o=";
  };

  vendorHash = "sha256-LrD6mfzilN+5nHBY/j2Jn+poc8ZXpr5rAs2oOkhDZNs=";

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
