{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "checkmate";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "adedayo";
    repo = "checkmate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bRsZIaerjEFJ/hyaXiVLG9xIChA0+Qm5TrupVCagvl0=";
  };

  vendorHash = "sha256-bXybxXl0qxHGLNTWaGWkLH6l8yrt9a37NMQO5cC2tyc=";

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
