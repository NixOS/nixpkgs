{
  lib,
  buildGoModule,
  fetchgit,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "stinkpot";
  version = "0.1.0";
  env.CGO_ENABLED = "0";
  ldflags = [
    "-s"
    "-w"
  ];
  src = fetchgit {
    url = "https://tangled.org/oppi.li/stinkpot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-grsoctCXQf7uzf6jmPQpfT+O7imnLQIp66/tPMeT3dY=";
  };

  vendorHash = "sha256-IVPACl1oWnBKGzcXvG5gzev8MwhzIKNI7zwEKJjhFc8=";

  passthru.updateScript = nix-update-script { };
  __structuredAttrs = true;

  meta = {
    description = "sqlite-backed shell history";
    homepage = "https://tangled.org/oppi.li/stinkpot";
    license = lib.licenses.mit;
    mainProgram = "stinkpot";
    maintainers = [ lib.maintainers.supermarin ];
    platforms = lib.platforms.unix;
  };
})
