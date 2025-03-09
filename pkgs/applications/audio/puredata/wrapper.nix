{
  symlinkJoin,
  puredata,
  makeWrapper,
  plugins,
}:

let
  puredataFlags = map (x: "-path ${x}/") plugins;
in
symlinkJoin {
  name = "puredata-with-plugins-${puredata.version}";

  paths = [ puredata ] ++ plugins;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/pd \
      --add-flags "${toString puredataFlags}"
  '';
}
