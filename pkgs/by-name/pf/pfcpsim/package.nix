{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "pfcpsim";
  version = "1.5.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omec-project";
    repo = "pfcpsim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RhroRtnHweZxQCHUFNlCCekUUrLvtu5YpGB8bKAT5ic=";
  };

  vendorHash = "sha256-Rb2MJbWqFbkTFLZs/oLPNFcmKDkXQt4IdPwnsdc4QXU=";

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
