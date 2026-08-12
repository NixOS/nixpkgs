{
  lib,
  buildJellyfinPlugin,
  fetchFromGitHub,
}:

buildJellyfinPlugin (finalAttrs: {
  pname = "jellyfin-plugin-dlna";
  version = "11";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-plugin-dlna";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2elz1x3+MDqPskqAcsH5iflB16+YClXK1b+D2oti0XA=";
  };

  projectFile = "Jellyfin.Plugin.Dlna.sln";
  nugetDeps = ./nuget-deps.json;

  meta = {
    description = "DLNA server plugin for Jellyfin";
    longDescription = ''
      Jellyfin served DLNA from its core until 10.9, which moved it out into
      this plugin. It advertises the library over SSDP and streams to DLNA
      renderers, transcoding when the device cannot play the source directly.
    '';
    homepage = "https://github.com/jellyfin/jellyfin-plugin-dlna";
    changelog = "https://github.com/jellyfin/jellyfin-plugin-dlna/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ clement-songis ];
  };
})
