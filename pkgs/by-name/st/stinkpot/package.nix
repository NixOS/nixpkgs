{
  lib,
  buildGoModule,
  fetchgit,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "stinkpot";
  version = "0.1.0-unstable-2026-08-01";
  env.CGO_ENABLED = "0";
  ldflags = [
    "-s"
    "-w"
  ];
  src = fetchgit {
    url = "https://tangled.org/oppi.li/stinkpot";
    rev = "8fa6de51adebb1ddeffbfb3b79c0885c2403575a";
    hash = "sha256-766l6US0ISPPO7ygPtYryInvLF9wF0q1fWc9IWlSGVY=";
  };

  vendorHash = "sha256-IVPACl1oWnBKGzcXvG5gzev8MwhzIKNI7zwEKJjhFc8=";

  passthru.updateScript = nix-update-script { };
  __structuredAttrs = true;

  meta = {
    description = "sqlite-backed shell history";
    mainProgram = "stinkpot";
    homepage = "https://tangled.org/oppi.li/stinkpot";
    maintainers = [ lib.maintainers.supermarin ];
    platforms = lib.platforms.unix;
  };
})
