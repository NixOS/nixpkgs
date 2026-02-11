{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "atproto-goat";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "bluesky-social";
    repo = "goat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jSwlKKMrUsb0stcPvC9i7dgH4DrlnUTwp+HYTwendB0=";
  };

  postPatch = ''
    substituteInPlace main.go \
      --replace-fail "versioninfo.Short()" '"${finalAttrs.version}"' \
      --replace-fail '"github.com/earthboundkid/versioninfo/v2"' ""
  '';

  vendorHash = "sha256-rqnCFBSmHaZWWc1MrK8udQLkK5MP4Yv2TTlozQqW0fc=";

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
