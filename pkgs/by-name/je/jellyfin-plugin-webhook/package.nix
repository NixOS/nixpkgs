{
  lib,
  buildJellyfinPlugin,
  fetchFromGitHub,
}:

buildJellyfinPlugin (finalAttrs: {
  pname = "jellyfin-plugin-webhook";
  version = "21";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-plugin-webhook";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a51Ff9G5LP+obf0ELzV6VEXParwU3Jv9zbCF61cC3UY=";
  };

  projectFile = "Jellyfin.Plugin.Webhook.sln";
  nugetDeps = ./nuget-deps.json;

  meta = {
    description = "Server event notifications over webhooks for Jellyfin";
    homepage = "https://github.com/jellyfin/jellyfin-plugin-webhook";
    changelog = "https://github.com/jellyfin/jellyfin-plugin-webhook/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ clement-songis ];
  };
})
