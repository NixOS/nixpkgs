{
  symlinkJoin,
  deadbeef,
  makeWrapper,
  plugins,
}:

symlinkJoin {
  pname = "deadbeef-with-plugins";
  inherit (deadbeef) version;

  paths = [ deadbeef ] ++ plugins;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/deadbeef \
      --set DEADBEEF_PLUGIN_DIR "$out/lib/deadbeef"
  '';
}
