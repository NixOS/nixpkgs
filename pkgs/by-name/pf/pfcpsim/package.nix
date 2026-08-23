{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "pfcpsim";
  version = "1.4.4";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omec-project";
    repo = "pfcpsim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c66j610yiifHM9RMuzWyzLbflz0hqdgPWFCXYJEF3ww=";
  };

  vendorHash = "sha256-Y2Ro+p2OJIlSvkf+nbGLv07F4UyV+0S+5FXyggYEZkE=";

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
