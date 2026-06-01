{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "kubectl-cnpg";
  version = "1.29.1";

  src = fetchFromGitHub {
    owner = "cloudnative-pg";
    repo = "cloudnative-pg";
    rev = "v${finalAttrs.version}";
    hash = "sha256-SlisY7v/CFVXH85IAvlBH1RjyrTS+e8hFHJIwh0FgCc=";
  };

  vendorHash = "sha256-He5L4HBTMOlzLgB+tAxNbjvDdvGyz5UolC8mMFibwZ4=";

  subPackages = [ "cmd/kubectl-cnpg" ];

  meta = {
    homepage = "https://cloudnative-pg.io/";
    description = "Plugin for kubectl to manage a CloudNativePG cluster in Kubernetes";
    mainProgram = "kubectl-cnpg";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ devusb ];
  };
})
