{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "pfcpsim";
  version = "1.5.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omec-project";
    repo = "pfcpsim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wwZ5DHpl55dWnFMlO7LgCL+wSWyGSLCOnKHT77qW/+Y=";
  };

  vendorHash = "sha256-/G6HCdCFAXPaI/M/WF+JMyZtz2RK56IYJYSZUZ0jfp4=";

  # Fuzzing cannot be performed without user plane function (upf)
  checkFlags = [ "-skip=^Fuzz$" ];

  meta = {
    description = "PFCP client simulator used for UPF testing";
    homepage = "https://github.com/omec-project/pfcpsim";
    changelog = "https://github.com/omec-project/pfcpsim/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ felbinger ];
    mainProgram = "pfcpctl";
  };
})
