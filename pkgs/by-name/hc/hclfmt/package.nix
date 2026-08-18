{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "hclfmt";
  version = "2.24.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "hcl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YWGd2rQXJ4AX8nhByYRdp+91PJeHrdCpxvKQntxzRhY=";
  };

  vendorHash = "sha256-5yGTuv19XyXsZcaHKXr/mYqKRufkJBaYMICFwMP/p3g=";

  # The code repository includes other tools which are not useful. Only build
  # hclfmt.
  subPackages = [ "cmd/hclfmt" ];

  meta = {
    description = "Code formatter for the Hashicorp Configuration Language (HCL) format";
    homepage = "https://github.com/hashicorp/hcl/tree/main/cmd/hclfmt";
    changelog = "https://github.com/hashicorp/hcl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    mainProgram = "hclfmt";
    maintainers = with lib.maintainers; [ zimbatm ];
  };
})
