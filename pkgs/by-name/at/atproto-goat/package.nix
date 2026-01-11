{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "atproto-goat";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "bluesky-social";
    repo = "goat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ECkazbwg25L8W8w7B6hlKD1rEAjGBRKaZ76rKSfR0vI=";
  };

  postPatch = ''
    substituteInPlace main.go \
      --replace-fail "versioninfo.Short()" '"${finalAttrs.version}"' \
      --replace-fail '"github.com/earthboundkid/versioninfo/v2"' ""
  '';

  vendorHash = "sha256-t35Y+llIr2vpBr/LA6WurqxUH7fVTgT9Y8OHX8v8xP4=";

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
