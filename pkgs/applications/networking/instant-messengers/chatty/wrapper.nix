{ symlinkJoin, pidgin, chatty, makeWrapper, plugins }:

let
  extraArgs = map (x: x.wrapArgs or "") plugins;
in symlinkJoin {
  name = "chatty-with-plugins-${chatty.version}";

  paths = [ chatty ] ++ plugins;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/chatty \
      --suffix-each PURPLE_PLUGIN_PATH ':' "$out/lib/purple-${pidgin.majorVersion}" \
      ${toString extraArgs}
  '';
}
