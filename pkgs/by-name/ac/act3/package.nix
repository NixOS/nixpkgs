{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
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

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Glance at the last 3 runs of your GitHub Actions workflows";
    homepage = "https://github.com/dhth/act3";
    license = lib.licenses.mit;
    mainProgram = "act3";
    maintainers = with lib.maintainers; [ phanirithvij ];
    platforms = lib.platforms.unix;
  };
})
