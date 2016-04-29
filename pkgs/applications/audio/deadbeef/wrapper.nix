{ stdenv, symlinkJoin, deadbeef, makeWrapper, plugins }:

symlinkJoin {
  name = "deadbeef-with-plugins-${deadbeef.version}";

  paths = [ deadbeef ] ++ plugins;

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/deadbeef \
      --set DEADBEEF_PLUGIN_DIR "$out/lib/deadbeef"
  '';
}
