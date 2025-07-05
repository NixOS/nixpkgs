{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pphack";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "edoardottt";
    repo = "pphack";
    tag = "v${version}";
    hash = "sha256-SWMY+t8NzbUqAeLsqia5KAXXOjoMRMZVVa8YdTLcG5A=";
  };

  vendorHash = "sha256-smJp3GDo1KOrEjEJnxtyrlHmb/L70QqhDWjCZ4U1qJs=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Client-Side Prototype Pollution Scanner";
    homepage = "https://github.com/edoardottt/pphack";
    changelog = "https://github.com/edoardottt/pphack/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pphack";
  };
}
