{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "nexusd";
  version = "3.4.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gammazero";
    repo = "nexus";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-vndK935rdMZZg+dwZhravmED1nErdYzL3nXp/DjJomo=";
  };

  vendorHash = "sha256-3GewVMHh8CD89gBLUDhh705z0LvCtG2l46s7BpxvK/U=";

  subPackages = [ "nexusd" ];

  meta = {
    description = "Full-feature WAMP v2 router written in Go";
    homepage = "https://github.com/gammazero/nexus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kiara ];
    mainProgram = "nexusd";
    platforms = lib.platforms.unix;
  };
})
