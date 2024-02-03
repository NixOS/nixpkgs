{ lib, symlinkJoin, pidgin, makeWrapper, plugins }:

let
extraArgs = map (x: x.wrapArgs or "") plugins;
in symlinkJoin {
  name = "pidgin-with-plugins-${pidgin.version}";

  paths = [ pidgin ] ++ plugins;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/pidgin \
      --suffix-each PURPLE_PLUGIN_PATH ':' "$out/lib/purple-${lib.versions.major pidgin.version} $out/lib/pidgin" \
      ${toString extraArgs}
    wrapProgram $out/bin/finch \
      --suffix-each PURPLE_PLUGIN_PATH ':' "$out/lib/purple-${lib.versions.major pidgin.version}" \
      ${toString extraArgs}
  '';
}
