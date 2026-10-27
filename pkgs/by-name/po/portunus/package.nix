{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libxcrypt,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "portunus";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "majewsky";
    repo = "portunus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PvsqI0kwO0pA2xOouI3DmhwzDCrtyBXCBXyWDy4bEmI=";
  };

  buildInputs = [ libxcrypt ];

  vendorHash = null;

  passthru.tests = { inherit (nixosTests) portunus; };

  meta = {
    description = "Self-contained user/group management and authentication service";
    homepage = "https://github.com/majewsky/portunus";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      majewsky
      SuperSandro2000
    ];
  };
})
