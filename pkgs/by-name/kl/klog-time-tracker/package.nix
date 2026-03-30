{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "klog-time-tracker";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "jotaen";
    repo = "klog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sqHtxaArJ+gStZwZ/bE/luJa7JphbrNgAES0nTKFYTE=";
  };

  vendorHash = "sha256-TyUGsJNWNEMPGg35oXorNFQ1Hjy9u3qRUVYXeabKDAM=";

  meta = {
    description = "Command line tool for time tracking in a human-readable, plain-text file format";
    homepage = "https://klog.jotaen.net";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.blinry ];
    mainProgram = "klog";
  };
})
