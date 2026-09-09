{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "kcl-kafka";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "twmb";
    repo = "kcl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dZb0NiT7K6V7itG/G8Zazl29N9Um2j6sPYU70XPXLCc=";
  };

  vendorHash = "sha256-u037xAngVhFe9MK+IVk85TNiZzqVzSNmuuI8sz/fya4=";

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
