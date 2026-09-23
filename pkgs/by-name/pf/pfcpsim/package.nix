{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "pfcpsim";
  version = "1.5.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omec-project";
    repo = "pfcpsim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YvqzuQn7srWH5QSPCeaxQKHPwjtmuiIo+l3v6QWIZko=";
  };

  vendorHash = "sha256-Q6ex6/O/gb8KDoOr9TNBkkj95/lJ8YLQLGpOlA1dxG4=";

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
