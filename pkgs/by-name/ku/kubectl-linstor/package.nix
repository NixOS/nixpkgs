{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
}:

buildGoModule rec {
  pname = "kubectl-linstor";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "piraeusdatastore";
    repo = "kubectl-linstor";
    tag = "v${version}";
    hash = "sha256-Fmy925eGGmXGoIT3EXmZDnHyu6nN7Rkgl2vQOhesqD4=";
  };

  vendorHash = "sha256-3PnXB8AfZtgmYEPJuh0fwvG38dtngoS/lxyx3H+rvFs=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Plugin to control a LINSTOR cluster using kubectl";
    homepage = "https://github.com/piraeusdatastore/kubectl-linstor";
    changelog = "https://github.com/piraeusdatastore/kubectl-linstor/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "kubectl-linstor";
  };
}
