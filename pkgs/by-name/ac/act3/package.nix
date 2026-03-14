{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "act3";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "dhth";
    repo = "act3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GE9f4hm+R4G4NCqdPN6h5MTZqMVLkrdMnc20bOZGcu4=";
  };

  vendorHash = "sha256-+WSWlmxQTryLrpeloYdupyMibsgFYpjSuDvW+if3IHE=";

  meta = {
    description = "Glance at the last 3 runs of your GitHub Actions workflows";
    homepage = "https://tools.dhruvs.space/act3/";
    downloadPage = "https://github.com/dhth/act3";
    changelog = "https://github.com/dhth/act3/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ artur-sannikov ];
  };
})
