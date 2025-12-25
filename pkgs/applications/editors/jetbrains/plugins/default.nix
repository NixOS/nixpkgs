{
  fetchurl,
  fetchzip,
  lib,
  stdenv,
  callPackage,
  autoPatchelfHook,
  glib,
  darwin,
}:
{
  tests = callPackage ./tests.nix { };

  addPlugins =
    ide: unprocessedPlugins:
    let
      processPlugin =
        plugin:
        # We can remove this check and just asume plugins to be derivations starting with 26.11.
        lib.throwIfNot (lib.isDerivation plugin)
          "addPlugins no longer supports resolving plugins by name or id strings. Please supply a derivation instead"
          plugin;

      plugins = map processPlugin unprocessedPlugins;
    in
    stdenv.mkDerivation rec {
      pname = meta.mainProgram + "-with-plugins";
      version = ide.version;
      src = ide;
      dontInstall = true;
      dontStrip = true;
      passthru.plugins = plugins ++ (ide.plugins or [ ]);
      newPlugins = plugins;
      disallowedReferences = [ ide ];
      nativeBuildInputs =
        (lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook)
        # The buildPhase hook rewrites the binary, which invaliates the code
        # signature. Add the fixup hook to sign the output.
        ++ (lib.optional stdenv.hostPlatform.isDarwin darwin.autoSignDarwinBinariesHook)
        ++ (ide.nativeBuildInputs or [ ]);
      buildInputs = lib.unique ((ide.buildInputs or [ ]) ++ [ glib ]);

      inherit (ide) meta;

      buildPhase =
        let
          appDir = lib.optionalString stdenv.hostPlatform.isDarwin "Applications/${lib.escapeShellArg ide.product}.app";
          rootDir = if stdenv.hostPlatform.isDarwin then "${appDir}/Contents" else meta.mainProgram;
        in
        ''
          cp -r ${ide} $out
          chmod +w -R $out
          rm -f $out/${rootDir}/plugins/plugin-classpath.txt

          (
            shopt -s nullglob

            IFS=' ' read -ra pluginArray <<< "$newPlugins"
            for plugin in "''${pluginArray[@]}"; do
              pluginfiles=($plugin)
              if [[ "$plugin" == *.jar ]]; then
                # if the plugin contains a single jar file, link it directly into the plugins folder
                ln -s "$plugin" $out/${rootDir}/plugins/
              else
                # otherwise link the plugin directory itself
                ln -s "$plugin" -t $out/${rootDir}/plugins/
              fi
            done

            for exe in $out/${rootDir}/bin/*; do
              if [ -x "$exe" ] && ( file "$exe" | grep -q 'text' ); then
                substituteInPlace "$exe" --replace-quiet '${ide}' $out
              fi
            done
          )
        '';
    };
}
