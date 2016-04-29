{ stdenv, symlinkJoin, pidgin, makeWrapper, plugins }:

let
extraArgs = map (x: x.wrapArgs or "") plugins;
in symlinkJoin {
  name = "pidgin-with-plugins-${pidgin.version}";

  paths = [ pidgin ] ++ plugins;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/pidgin \
      --suffix-each PURPLE_PLUGIN_PATH ':' "$out/lib/purple-${pidgin.majorVersion} $out/lib/pidgin" \
      ${toString extraArgs}
  '';
}
