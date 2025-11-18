{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mmdbinspect";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "mmdbinspect";
    tag = "v${version}";
    hash = "sha256-3QEk8glTtUd1BACKNKNjli8cI8qsdGMeFb9fVVAbLSs=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-qQTllOx1GRKven+zItnU9Uf0l9HfRt5b6YkloJSrDKk=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Look up records for one or more IPs/networks in one or more .mmdb databases";
    homepage = "https://github.com/maxmind/mmdbinspect";
    changelog = "https://github.com/maxmind/mmdbinspect/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "mmdbinspect";
  };
}
