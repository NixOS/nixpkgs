{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "checkmate";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = "checkmate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-163Cuma3110EztauICtiNZvWxIRFjTvYZF2mD6C0vjE=";
  };

  vendorHash = "sha256-BhdRAlMKjhb2haRb38JYBMTIMa4iFJEfzxWLQuMC1bI=";

  subPackages = [ "." ];

  meta = {
    description = "Pluggable code security analysis tool";
    mainProgram = "checkmate";
    homepage = "https://github.com/adedayo/checkmate";
    changelog = "https://github.com/adedayo/checkmate/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
