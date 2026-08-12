{
  lib,
  buildJellyfinPlugin,
  fetchFromGitHub,
}:

buildJellyfinPlugin (finalAttrs: {
  pname = "jellyfin-plugin-reports";
  version = "18";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-plugin-reports";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FK2bbAId228ZEFKcQzVagH7g31XFfwDUAFKJhCsujfQ=";
  };

  projectFile = "Jellyfin.Plugin.Reports.sln";
  nugetDeps = ./nuget-deps.json;

  meta = {
    description = "Library and activity reports for Jellyfin";
    homepage = "https://github.com/jellyfin/jellyfin-plugin-reports";
    changelog = "https://github.com/jellyfin/jellyfin-plugin-reports/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ clement-songis ];
  };
})
