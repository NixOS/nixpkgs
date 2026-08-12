{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  jellyfin,
  nix-update-script,
  yq-go,
}:

# Builds a Jellyfin plugin into $out/lib/jellyfin/plugins/<Name>_<Version>,
# the layout services.jellyfin.plugins reproduces under the server's data
# directory. The manifest is generated from upstream's build.yaml so that
# nix-update can bump a plugin on its own.
#
# Takes buildDotnetModule's arguments, as an attribute set or a function of
# finalAttrs, with `version` given as upstream's own (the vN tag); it is padded
# to the four components Jellyfin compares on.

fnOrAttrs:

buildDotnetModule (
  finalAttrs:
  let
    args = if lib.isFunction fnOrAttrs then fnOrAttrs finalAttrs else fnOrAttrs;

    # "11" -> "11.0.0.0", "1.2" -> "1.2.0.0".
    pluginVersion = lib.concatStringsSep "." (
      lib.take 4 (
        lib.splitString "." finalAttrs.version
        ++ [
          "0"
          "0"
          "0"
        ]
      )
    );
  in
  (removeAttrs args [
    "meta"
    "passthru"
  ])
  // {
    dotnet-sdk = args.dotnet-sdk or dotnetCorePackages.sdk_9_0;
    dotnet-runtime = args.dotnet-runtime or dotnetCorePackages.aspnetcore_9_0;

    executables = [ ];

    nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ yq-go ];

    # Plugins hardcode 0.0.0.0 in Directory.Build.Props and rely on upstream's
    # CI passing the real version.
    dotnetBuildFlags = (args.dotnetBuildFlags or [ ]) ++ [ "-p:Version=${pluginVersion}" ];

    postInstall = ''
      buildYaml=$NIX_BUILD_TOP/source/build.yaml
      if [[ ! -e $buildYaml ]]; then
        echo "buildJellyfinPlugin: no build.yaml at the source root; this does not" >&2
        echo "look like a Jellyfin plugin." >&2
        exit 1
      fi

      if [[ $(yq -r '.version' "$buildYaml") != ${lib.escapeShellArg finalAttrs.version} ]]; then
        echo "buildJellyfinPlugin: version is ${finalAttrs.version} but build.yaml" >&2
        echo "declares $(yq -r '.version' "$buildYaml")." >&2
        exit 1
      fi

      # A plugin needing a newer server than we package is skipped silently at
      # startup, so an unattended bump would ship something that does nothing.
      targetAbi="$(yq -r '.targetAbi' "$buildYaml")"
      oldest="$(printf '%s\n%s\n' "$targetAbi" ${lib.escapeShellArg jellyfin.version} \
        | sort --version-sort | head -1)"
      if [[ $oldest != "$targetAbi" ]]; then
        echo "buildJellyfinPlugin: this plugin needs Jellyfin $targetAbi or newer," >&2
        echo "but nixpkgs has ${jellyfin.version}. Bump jellyfin first, or hold this" >&2
        echo "plugin back: the server would skip it without any visible error." >&2
        exit 1
      fi

      pluginDir="$out/lib/jellyfin/plugins/$(yq -r '.name' "$buildYaml")_${pluginVersion}"
      mkdir -p "$pluginDir"

      # A solution builds more assemblies than the plugin ships; the extras are
      # libraries the server already provides.
      readarray -t artifacts < <(yq -r '.artifacts[]' "$buildYaml")
      for artifact in "''${artifacts[@]}"; do
        mv "$out/lib/${finalAttrs.pname}/$artifact" "$pluginDir/"
      done

      # status and autoUpdate are ours: the assemblies are read-only store
      # paths, so an in-place update can only fail.
      VERSION=${lib.escapeShellArg pluginVersion} \
        yq -o=json '{
          "category": .category,
          "description": .description,
          "guid": .guid,
          "name": .name,
          "overview": .overview,
          "owner": .owner,
          "targetAbi": .targetAbi,
          "version": strenv(VERSION),
          "assemblies": .artifacts,
          "status": "Active",
          "autoUpdate": false,
          "timestamp": "1970-01-01T00:00:00Z"
        }' "$buildYaml" > "$pluginDir/meta.json"

      rm -rf "$out/lib/${finalAttrs.pname}"
    '';

    passthru = {
      updateScript = nix-update-script {
        extraArgs = [ "--version-regex=v([0-9.]+)" ];
      };
    }
    // (args.passthru or { });

    meta = {
      license = lib.licenses.gpl3Only;
      platforms = lib.platforms.all;
    }
    // (args.meta or { });
  }
)
