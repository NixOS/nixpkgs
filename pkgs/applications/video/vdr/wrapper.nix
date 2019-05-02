{ symlinkJoin, lib, makeWrapper, vdr, plugins ? [] }:
symlinkJoin {

  name = "vdr-with-plugins-${(builtins.parseDrvName vdr.name).version}";

  paths = [ vdr ] ++ plugins;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/vdr --add-flags "-L $out/lib/vdr --localedir=$out/share/locale"
  '';

  meta = with vdr.meta; {
    inherit license homepage;
    description = description
    + " (with plugins: "
    + lib.concatStrings (lib.intersperse ", " (map (x: ""+x.name) plugins))
    + ")";
  };
}
