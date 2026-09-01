{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "bitcrook";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "ax-i-om";
    repo = "bitcrook";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O2u5e6LmfrxsfrBY3OPFTottheGO+ue8qMLqbDVMBhA=";
  };

  vendorHash = "sha256-19uN+jTqZDqIu/rqS/U9JSnZWowTlLAgHG7+YhXaOd4=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  # Tests require network access
  doCheck = false;

  meta = {
    description = "Tool to do OSINT";
    homepage = "https://github.com/ax-i-om/bitcrook";
    changelog = "https://github.com/ax-i-om/bitcrook/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "bitcrook";
  };
})
