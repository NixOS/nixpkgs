{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "certgraph";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "lanrat";
    repo = "certgraph";
    tag = "v${version}";
    hash = "sha256-WlNrKmny4fODnSEkP8HUF+VzMX1/LKYMdSnm7DON8Po=";
  };

  vendorHash = "sha256-4wj96eDibGB3oX56yIr01CYLZCYMFnfoaPWaNdFH7IE=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-w"
    "-s"
    "-X=main.version=${version}"
  ];

  doInstallCheck = true;

  meta = {
    description = "Intelligence tool to crawl the graph of certificate alternate names";
    homepage = "https://github.com/lanrat/certgraph";
    changelog = "https://github.com/lanrat/certgraph/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "certgraph";
  };
}
