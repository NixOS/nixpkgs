{
  lib,
  buildJellyfinPlugin,
  fetchFromGitHub,
}:

buildJellyfinPlugin (finalAttrs: {
  pname = "jellyfin-plugin-trakt";
  version = "30";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-plugin-trakt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jqHZnkkrJ11SQHllnwCqg8an7HPpEfyC4gVhiY9nPag=";
  };

  projectFile = "Trakt.sln";
  nugetDeps = ./nuget-deps.json;

  meta = {
    description = "Trakt.tv scrobbling and library sync for Jellyfin";
    homepage = "https://github.com/jellyfin/jellyfin-plugin-trakt";
    changelog = "https://github.com/jellyfin/jellyfin-plugin-trakt/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ clement-songis ];
  };
})
