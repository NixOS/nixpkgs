{
  lib,
  buildJellyfinPlugin,
  fetchFromGitHub,
}:

buildJellyfinPlugin (finalAttrs: {
  pname = "jellyfin-plugin-opensubtitles";
  version = "24";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-plugin-opensubtitles";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QkvZ/JAztkr1KwaQuVatPyN/eaWlXuUF18r8HvofAww=";
  };

  projectFile = "Jellyfin.Plugin.OpenSubtitles.sln";
  nugetDeps = ./nuget-deps.json;

  meta = {
    description = "Subtitle downloads from OpenSubtitles for Jellyfin";
    homepage = "https://github.com/jellyfin/jellyfin-plugin-opensubtitles";
    changelog = "https://github.com/jellyfin/jellyfin-plugin-opensubtitles/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ clement-songis ];
  };
})
