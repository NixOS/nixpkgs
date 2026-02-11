{
  lib,
  buildGoLatestModule,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoLatestModule (finalAttrs: {
  pname = "age-keylookup";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "torchwood";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eSDbIOzWKRlmGXj+/LlaT22HDC77Uyz96fTTR9vWbWk=";
  };

  subPackages = [ "cmd/age-keylookup" ];

  vendorHash = "sha256-S1/PInF5TvvuY/lcn5DPQS5NJJaiH3y1gXZZzJzWvtU=";

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    homepage = "https://github.com/FiloSottile/torchwood";
    description = "Tool to look up age public keys from a keyserver";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rixxc ];
    platforms = lib.platforms.all;
  };
})
