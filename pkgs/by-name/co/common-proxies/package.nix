{
  lib,
  fetchFromCodeberg,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "common-proxies";
  version = "3.2.0";

  src = fetchFromCodeberg {
    owner = "UnifiedPush";
    repo = "common-proxies";
    rev = finalAttrs.version;
    hash = "sha256-GUZ6/GpxqhhHFsq/DIWaNhipKfJCKr4t8ptMOhZxGkc=";
  };

  vendorHash = "sha256-qIfca8ebt6+i27X2Gt0m39cmddA5ucbxQmQUyQoItd0=";

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    description = "Set of rewrite proxies and gateways for UnifiedPush";
    homepage = "https://codeberg.org/UnifiedPush/common-proxies";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.zimward ];
    mainProgram = "common-proxies";
  };
})
