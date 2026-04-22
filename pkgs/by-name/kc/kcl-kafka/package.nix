{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kcl-kafka";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "twmb";
    repo = "kcl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P55k9PIUDtYMzgPHCQYQLNgprnC9MDUX6ZfgZhI9fC0=";
  };

  vendorHash = "sha256-o7iSFI0zRwjlE2MVqKSpPMowR4mD2zW6wez4sqNX4Cw=";

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
