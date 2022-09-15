{ fetchurl
, fetchzip
, lib
, stdenv
, callPackage
, autoPatchelfHook
}: with builtins;
# These functions do NOT check for plugin compatibility
# Check by installing manually first

let
  fetchPluginSrc = { hash, url, id, name, special ? false, version ? null, ... }: let
    isJar = lib.hasSuffix ".jar" url;
    fetcher = if isJar then fetchurl else fetchzip;
  in fetcher {
    executable = isJar;
    inherit url hash;
    passthru = { inherit id name special version; };
  };

  mkPlugin = x: stdenv.mkDerivation ({installPhase = "mkdir $out && cp -r . $out";} // x);

  specialPluginsInfo = callPackage ./specialPlugins.nix {};
  plugins = fromJSON (readFile ./plugins.json);
  pluginsWithSpecial = mapAttrs
    (id: value: value // { special = specialPluginsInfo ? "${id}"; inherit id; } // (specialPluginsInfo."${id}" or {})) plugins;
  pluginsWithSrcs = mapAttrs
    (id: value: value // { src = fetchPluginSrc value; }) pluginsWithSpecial;
  pluginsWithResult = mapAttrs
    (id: value: { result = if value.special then mkPlugin value else value.src; } // value) pluginsWithSrcs;
  byId = mapAttrs (id: value: value.result) pluginsWithResult;
  byName = lib.mapAttrs'
    (key: value: lib.attrsets.nameValuePair value.name value.result) pluginsWithResult;

in rec {
  inherit fetchPluginSrc byId byName;

  addPlugins = ide: plugins: stdenv.mkDerivation rec {
     pname = meta.mainProgram + "-with-plugins";
     version = ide.version;
     src = ide;
     dontInstall = true;
     dontFixup = true;
     passthru.plugins = plugins ++ (ide.plugins or []);
     newPlugins = plugins;
     disallowedReferences = [ ide ];
     nativeBuildInputs = [ autoPatchelfHook ] ++ (ide.nativeBuildInputs or []);
     buildInputs = ide.buildInputs or [];

     inherit (ide) meta;

     buildPhase = let
       pluginCmdsLines = map (plugin: "ln -s ${plugin} \"$out\"/${meta.mainProgram}/plugins/${baseNameOf plugin}") plugins;
       pluginCmds = concatStringsSep "\n" pluginCmdsLines;
       extraBuildPhase = rec {
         clion = ''
           sed "s|${ide}|$out|" -i $out/bin/.clion-wrapped
           autoPatchelf $out/clion/bin
         '';
       };
     in ''
       cp -r ${ide} $out
       chmod +w -R $out
       IFS=' ' read -ra pluginArray <<< "$newPlugins"
       for plugin in "''${pluginArray[@]}"
       do
        ln -s "$plugin" -t $out/${meta.mainProgram}/plugins/
       done
       sed "s|${ide.outPath}|$out|" -i $out/bin/${meta.mainProgram}
       '' + (extraBuildPhase."${ide.meta.mainProgram}" or "");
  };
}
