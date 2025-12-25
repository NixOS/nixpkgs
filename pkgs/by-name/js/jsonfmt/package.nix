{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule rec {
  pname = "jsonfmt";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "jsonfmt";
    tag = "v${version}";
    hash = "sha256-CMBqqTGpqoErFPKn4lxMB9XrdlhZcY6qbRZZVUVMQj0=";
  };

  vendorHash = "sha256-QcljmDsz5LsXfHaXNVBU7IIVVgkm3Vfnirchx5ZOMSg=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  doInstallCheck = true;

  meta = {
    description = "Formatter for JSON files";
    homepage = "https://github.com/caarlos0/jsonfmt";
    changelog = "https://github.com/caarlos0/jsonfmt/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "jsonfmt";
  };
}
