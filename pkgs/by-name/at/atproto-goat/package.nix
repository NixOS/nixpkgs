{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "atproto-goat";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "bluesky-social";
    repo = "goat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xbvSO3keFheklnzPNEceS01CjIG3pPB+8e2M+3PD85U=";
  };

  postPatch = ''
    substituteInPlace main.go \
      --replace-fail "versioninfo.Short()" '"${finalAttrs.version}"' \
      --replace-fail '"github.com/earthboundkid/versioninfo/v2"' ""
  '';

  vendorHash = "sha256-hLsMme054E23NV8GDHsmZTYh/vY/w8gKWvpVIPeAiCY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go AT protocol CLI tool";
    homepage = "https://github.com/bluesky-social/goat/blob/main/README.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "goat";
  };
})
