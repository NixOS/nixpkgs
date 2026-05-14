{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kcl-kafka";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "twmb";
    repo = "kcl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BCLwgDDVp3mqQEJnPt97nEbpaYmm8a7jzO45Vn2bUaQ=";
  };

  vendorHash = "sha256-FTh3YLfWL1L4WiRcaz5beS4/mHbtPEXG8V85VmSndWo=";

  subPackages = [ "." ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "One stop shop to do anything with Apache Kafka";
    homepage = "https://github.com/twmb/kcl";
    changelog = "https://github.com/twmb/kcl/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ chillcicada ];
    mainProgram = "kcl";
  };
})
