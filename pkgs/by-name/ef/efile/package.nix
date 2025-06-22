{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "efile";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "Beriholic";
    repo = "efile";
    tag = "${finalAttrs.version}";
    hash = "sha256-qAPzGw+DQ1uKmZxCaZZSvcf59k5AsxHyXs339q2J2OU=";
  };

  vendorHash = "sha256-X/LCfIWlnCrNvgAdHED83Eppz2SLS9kvFdFsOuRGSZs=";

  meta = {
    description = "Cli tool for simple encryption of files";
    homepage = "https://github.com/Beriholic/efile";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ beriholic ];
    mainProgram = "efile";
  };
})
