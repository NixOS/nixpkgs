{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  writers,
}:

buildDotnetModule (finalAttrs: {
  pname = "jellyfin-plugin-dlna";
  # Upstream tags releases `vN`, but the assembly and the published artifact
  # are versioned `N.0.0.0`, which is also what Jellyfin compares plugin
  # folders and manifests against.
  version = "11.0.0.0";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-plugin-dlna";
    tag = "v${lib.versions.major finalAttrs.version}";
    hash = "sha256-2elz1x3+MDqPskqAcsH5iflB16+YClXK1b+D2oti0XA=";
  };

  projectFile = "Jellyfin.Plugin.Dlna.sln";
  nugetDeps = ./nuget-deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.aspnetcore_9_0;

  # src/Directory.Build.Props hardcodes 0.0.0.0; upstream's CI passes the real
  # version on the command line. Without this the assembly reports 0.0.0.0 and
  # Jellyfin's plugin manager treats every rebuild as the same version.
  dotnetBuildFlags = [ "-p:Version=${finalAttrs.version}" ];

  # A plugin is a library: there is nothing to wrap, and the default
  # `executables = null` would try to install every project as a binary.
  executables = [ ];

  # Jellyfin discovers plugins by enumerating the subdirectories of its
  # `plugins` folder and reading `meta.json` from each. The versioned
  # `Name_Version` folder is a legacy fallback that upstream documents as being
  # phased out, so the manifest is what we ship.
  postInstall =
    let
      # Mirrors upstream's build.yaml, which is what the official repository
      # manifest is generated from.
      meta = {
        category = "General";
        description = "Adds DLNA capability to Jellyfin";
        guid = "33eba9cd-7da1-4720-967f-dd7dae7b74a1";
        name = "DLNA";
        overview = "DLNA Service";
        owner = "jellyfin";
        # The plugin is skipped at startup unless the running server is at
        # least this version, so it has to track build.yaml rather than the
        # jellyfin package.
        targetAbi = "10.11.9.0";
        version = finalAttrs.version;
        status = "Active";
        # Nothing here is allowed to auto-update: the store is read-only, and
        # an update would be lost on the next rebuild anyway.
        autoUpdate = false;
        assemblies = [
          "Jellyfin.Plugin.Dlna.dll"
          "Jellyfin.Plugin.Dlna.Model.dll"
          "Jellyfin.Plugin.Dlna.Playback.dll"
          "Rssdp.dll"
        ];
        timestamp = "1970-01-01T00:00:00Z";
      };
      metaFile = (writers.writeJSON "meta.json" meta);
    in
    ''
      plugin="$out/lib/jellyfin/plugins/${finalAttrs.passthru.pluginName}"
      mkdir -p "$plugin"

      for dll in ${lib.concatStringsSep " " meta.assemblies}; do
        mv "$out/lib/${finalAttrs.pname}/$dll" "$plugin/"
      done
      cp ${metaFile} "$plugin/meta.json"

      rm -rf "$out/lib/${finalAttrs.pname}"
    '';

  passthru = {
    # The directory name Jellyfin will see. Kept in passthru so a NixOS module
    # can link the plugin into place without re-deriving it from the manifest.
    pluginName = "DLNA_${finalAttrs.version}";
  };

  meta = {
    description = "DLNA server plugin for Jellyfin";
    longDescription = ''
      Jellyfin served DLNA from its core until 10.9, which moved it out into
      this plugin. It advertises the library over SSDP and streams to DLNA
      renderers, transcoding when the device cannot play the source directly.
    '';
    homepage = "https://github.com/jellyfin/jellyfin-plugin-dlna";
    changelog = "https://github.com/jellyfin/jellyfin-plugin-dlna/releases/tag/v${lib.versions.major finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ clement-songis ];
    platforms = lib.platforms.all;
  };
})
