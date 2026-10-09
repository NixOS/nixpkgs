{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "pfcpsim";
  version = "1.5.6";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omec-project";
    repo = "pfcpsim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MhZKtYs/Y6C93ALecfN0H44/JTXyGmd4LRnhZ4O7jws=";
  };

  vendorHash = "sha256-Qm/Ca/EskbJfQdgxxSGk0TL2pgKU60ueiFjMQEAqCJ0=";

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
