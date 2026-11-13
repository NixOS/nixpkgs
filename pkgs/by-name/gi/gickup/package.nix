{
  lib,
  git,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "gickup";
  version = "0.10.47";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cooperspencer";
    repo = "gickup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wa5G7As/eoRytyojsUSciKkVtJ3SoamyZy5t1vd/WBE=";
  };

  vendorHash = "sha256-MF5nvbtJBJSZ7y1o3dH2F8dcdNJP+cogV1q5b0o9NcM=";

  ldflags = [ "-X main.version=${finalAttrs.version}" ];

  nativeCheckInputs = [ git ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to backup repositories";
    homepage = "https://github.com/cooperspencer/gickup";
    changelog = "https://github.com/cooperspencer/gickup/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ pedrosandre ];
    mainProgram = "gickup";
    license = lib.licenses.asl20;
  };
})
