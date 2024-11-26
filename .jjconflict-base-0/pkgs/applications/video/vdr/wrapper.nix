{
  symlinkJoin,
  lib,
  makeWrapper,
  vdr,
  plugins ? [ ],
}:
let

  makeXinePluginPath = l: lib.concatStringsSep ":" (map (p: "${p}/lib/xine/plugins") l);

  requiredXinePlugins = lib.flatten (map (p: p.passthru.requiredXinePlugins or [ ]) plugins);

in
symlinkJoin {

  name = "vdr-with-plugins-${lib.getVersion vdr}";

  paths = [ vdr ] ++ plugins;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/vdr \
      --add-flags "-L $out/lib/vdr --localedir=$out/share/locale" \
      --prefix XINE_PLUGIN_PATH ":" ${lib.escapeShellArg (makeXinePluginPath requiredXinePlugins)}
  '';

  meta = with vdr.meta; {
    inherit license homepage;
    description =
      description + " (with plugins: " + lib.concatStringsSep ", " (map (x: "" + x.name) plugins) + ")";
  };
}
