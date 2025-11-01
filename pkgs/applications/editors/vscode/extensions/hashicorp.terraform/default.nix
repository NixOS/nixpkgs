{
  lib,
  vscode-utils,
  jq,
  moreutils,
  terraform-ls,
  vscode-extension-update-script,
}:

vscode-utils.buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "terraform";
    publisher = "hashicorp";
    version = "2.37.5";
    hash = "sha256-FmeO7RKzQb/wKO34Bues9IlYxd9O3/oCNmByIrv4+J0=";
  };

  postInstall = ''
    cd "$out/$installPrefix"
    ${lib.getExe jq} '.contributes.configuration[0].properties."terraform.languageServer.path".default = "${terraform-ls}/bin/terraform-ls"' package.json | ${lib.getExe' moreutils "sponge"} package.json
  '';

  passthru.updateScript = vscode-extension-update-script {
    extraArgs = [
      "--override-filename"
      "pkgs/applications/editors/vscode/extensions/hashicorp.terraform/default.nix"
    ];
  };

  meta = {
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.rhoriguchi ];
  };
}
