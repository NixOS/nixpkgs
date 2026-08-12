{
  lib,
  buildJellyfinPlugin,
  fetchFromGitHub,
}:

buildJellyfinPlugin (finalAttrs: {
  pname = "jellyfin-plugin-tvdb";
  version = "22";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-plugin-tvdb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3cTzCKKgvnwwdaCJv70qAl5j73hixM4cCKVr1KOLh5A=";
  };

  projectFile = "Jellyfin.Plugin.Tvdb.sln";
  nugetDeps = ./nuget-deps.json;

  meta = {
    description = "TheTVDB metadata provider for Jellyfin";
    homepage = "https://github.com/jellyfin/jellyfin-plugin-tvdb";
    changelog = "https://github.com/jellyfin/jellyfin-plugin-tvdb/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ clement-songis ];
  };
})
