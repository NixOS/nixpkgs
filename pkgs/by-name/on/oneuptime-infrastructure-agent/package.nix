{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "oneuptime-infrastructure-agent";
  version = "14.0.10";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OneUptime";
    repo = "oneuptime";
    tag = finalAttrs.version;
    hash = "sha256-AcbAL+jsYsEoSIcIcWU2xypWt232Fi/5+bVt0Unnojk=";
  };

  sourceRoot = "${finalAttrs.src.name}/agents/InfrastructureAgent";

  vendorHash = "sha256-44Z1GWZcSCh+AFfsxwJIMw9pqzgg2IuzkQEpCUOephk=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Agent that reports host metrics to a OneUptime server";
    homepage = "https://github.com/OneUptime/oneuptime";
    changelog = "https://github.com/OneUptime/oneuptime/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "oneuptime-infrastructure-agent";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
