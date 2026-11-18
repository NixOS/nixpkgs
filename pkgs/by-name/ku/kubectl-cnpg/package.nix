{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-cnpg";
  version = "1.30.2";

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9/LnPIrGD482YAFt6pevRAaZp5r/SW1pR2sNbmADX+U=";
  };

  vendorHash = "sha256-Xd0FK69H2lww9oFrAHl/IcVZc5+BfIc51VLU2nzV2qk=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    mainProgram = "kubectl-cnpg";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ devusb ];
  };
})
