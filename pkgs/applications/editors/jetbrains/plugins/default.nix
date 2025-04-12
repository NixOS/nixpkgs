{ fetchurl
, fetchzip
, lib
, stdenv
, callPackage
, autoPatchelfHook
, glib
}:

let
  pluginsJson = builtins.fromJSON (builtins.readFile ./plugins.json);
  specialPluginsInfo = callPackage ./specialPlugins.nix { };
  fetchPluginSrc = url: hash:
    let
      isJar = lib.hasSuffix ".jar" url;
      fetcher = if isJar then fetchurl else fetchzip;
    in
    fetcher {
      executable = isJar;
      inherit url hash;
    };
  files = builtins.mapAttrs (key: value: fetchPluginSrc key value) pluginsJson.files;
  ids = builtins.attrNames pluginsJson.plugins;

  mkPlugin = id: file:
    if !specialPluginsInfo ? "${id}"
    then files."${file}"
    else
      stdenv.mkDerivation ({
        name = "jetbrains-plugin-${id}";
        installPhase = ''
          runHook preInstall
          mkdir -p $out && cp -r . $out
          runHook postInstall
        '';
        src = files."${file}";
      } // specialPluginsInfo."${id}");

  selectFile = id: ide: build:
    if !builtins.elem ide pluginsJson.plugins."${id}".compatible then
      throw "Plugin with id ${id} does not support IDE ${ide}"
    else if !pluginsJson.plugins."${id}".builds ? "${build}" then
      throw "Jetbrains IDEs with build ${build} are not in nixpkgs. Try update_plugins.py with --with-build?"
    else if pluginsJson.plugins."${id}".builds."${build}" == null then
      throw "Plugin with id ${id} does not support build ${build}"
    else
      pluginsJson.plugins."${id}".builds."${build}";

  byId = builtins.listToAttrs
    (map
      (id: {
        name = id;
        value = ide: build: mkPlugin id (selectFile id ide build);
      })
      ids);

  byName = builtins.listToAttrs
    (map
      (id: {
        name = pluginsJson.plugins."${id}".name;
        value = byId."${id}";
      })
      ids);


in {
  # Only use if you know what youre doing
  raw = { inherit files byId byName; };

  tests = callPackage ./tests.nix {};

  addPlugins = ide: unprocessedPlugins:
    let

      processPlugin = plugin:
        if lib.isDerivation plugin then plugin else
        if byId ? "${plugin}" then byId."${plugin}" ide.pname ide.buildNumber else
        if byName ? "${plugin}" then byName."${plugin}" ide.pname ide.buildNumber else
        throw "Could not resolve plugin ${plugin}";

      plugins = map processPlugin unprocessedPlugins;

    in
    stdenv.mkDerivation rec {
      pname = meta.mainProgram + "-with-plugins";
      version = ide.version;
      src = ide;
      dontInstall = true;
      dontFixup = true;
      passthru.plugins = plugins ++ (ide.plugins or [ ]);
      newPlugins = plugins;
      disallowedReferences = [ ide ];
      nativeBuildInputs = (lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook) ++ (ide.nativeBuildInputs or [ ]);
      buildInputs = lib.unique ((ide.buildInputs or [ ]) ++ [ glib ]);

      inherit (ide) meta;

      buildPhase =
      let
        rootDir = if stdenv.hostPlatform.isDarwin then "Applications/${ide.product}.app/Contents" else meta.mainProgram;
      in
      ''
        cp -r ${ide} $out
        chmod +w -R $out
        rm -f $out/${rootDir}/plugins/plugin-classpath.txt
        IFS=' ' read -ra pluginArray <<< "$newPlugins"
        for plugin in "''${pluginArray[@]}"
        do
          pluginfiles=$(ls $plugin);
          if [ $(echo $pluginfiles | wc -l) -eq 1 ] && echo $pluginfiles | grep -E "\.jar" 1> /dev/null; then
            # if the plugin contains a single jar file, link it directly into the plugins folder
            ln -s "$plugin/$(echo $pluginfiles | head -1)" $out/${rootDir}/plugins/
          else
            # otherwise link the plugin directory itself
            ln -s "$plugin" -t $out/${rootDir}/plugins/
          fi
        done
        sed "s|${ide.outPath}|$out|" \
          -i $(realpath $out/bin/${meta.mainProgram})

        if test -f "$out/bin/${meta.mainProgram}-remote-dev-server"; then
          sed "s|${ide.outPath}|$out|" \
            -i $(realpath $out/bin/${meta.mainProgram}-remote-dev-server)
        fi

      '' + lib.optionalString stdenv.hostPlatform.isLinux ''
        autoPatchelf $out
      '';
    };
}
