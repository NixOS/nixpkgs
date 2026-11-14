{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kcl-kafka";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "twmb";
    repo = "kcl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yqkhc+4wwiQ0ZbwtFNcGMmwS3Pzw2AAhRwpTxy2Yix4=";
  };

  vendorHash = "sha256-+AoXU2kN+qfEzMRbcb3PK+g5D14fHE/IQEcjG2/uYtQ=";

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
