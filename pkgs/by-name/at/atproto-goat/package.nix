{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "atproto-goat";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "bluesky-social";
    repo = "goat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mI7GC0ElE+FxT7v29V/a+UZBI1d6os+HpEO5WYWxm6A=";
  };

  postPatch = ''
    substituteInPlace main.go \
      --replace-fail "versioninfo.Short()" '"${finalAttrs.version}"' \
      --replace-fail '"github.com/earthboundkid/versioninfo/v2"' ""
  '';

  vendorHash = "sha256-QVnpISwYri8aL4umZWi2LJ0X13CXXK7JygaBh1Sq5PA=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Go AT protocol CLI tool";
    homepage = "https://github.com/bluesky-social/goat/blob/main/README.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      pyrox0
      isabelroses
    ];
    mainProgram = "goat";
  };
})
