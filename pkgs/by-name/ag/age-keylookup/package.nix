{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "age-keylookup";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "torchwood";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uQTdI9nB3nHWWnasWN+qxgG8HX64vNeluL3p+F00Yg0=";
  };

  subPackages = [ "cmd/age-keylookup" ];

  vendorHash = "sha256-xSdnfVLbQuKvGkQhQciUtG123OV3QgxqzJl+fbh7WrI=";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/FiloSottile/torchwood";
    description = "Tool to look up age public keys from a keyserver";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rixxc ];
    platforms = lib.platforms.all;
  };
})
