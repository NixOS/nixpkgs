{
  lib,
  mkPackerPlugin,
  fetchFromGitHub,
}:

mkPackerPlugin (finalAttrs: {

  pname = "packer-plugin-azure";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "packer-plugin-azure";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/qPiWEdyIbykDlGeP5UX4WkD7jgka64D3oRPwTLsnKo=";
  };

  vendorHash = "sha256-Wr+7GFORRzhYmQkgAvGFm7z22n8azaaCZjOcWuvZJ2s=";

  meta = {
    description = "Packer plugin for Azure";
    homepage = "https://github.com/hashicorp/packer-plugin-azure";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
