{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "oneuptime-infrastructure-agent";
  version = "12.0.33";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OneUptime";
    repo = "oneuptime";
    tag = finalAttrs.version;
    hash = "sha256-rbubW94htXyIV6vNxz8YWv4wkMX3a25Dg+IF2aitgMI=";
  };

  sourceRoot = "${finalAttrs.src.name}/InfrastructureAgent";

  vendorHash = "sha256-CD+6MJgLf9IhlIhvbWCJBMRp/V+/25Z+4m88rYHhbHg=";

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
