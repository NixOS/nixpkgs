{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "jsonfmt";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "jsonfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CMBqqTGpqoErFPKn4lxMB9XrdlhZcY6qbRZZVUVMQj0=";
  };

  vendorHash = "sha256-QcljmDsz5LsXfHaXNVBU7IIVVgkm3Vfnirchx5ZOMSg=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  meta = {
    description = "Formatter for JSON files";
    homepage = "https://github.com/caarlos0/jsonfmt";
    changelog = "https://github.com/caarlos0/jsonfmt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    mainProgram = "jsonfmt";
  };
})
