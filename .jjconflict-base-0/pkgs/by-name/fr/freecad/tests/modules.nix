{
  freecad,
  runCommand,
  writeTextFile,
}:
let
  mkModule =
    n:
    writeTextFile {
      name = "module-${n}";
      destination = "/Init.py";
      text = ''
        import sys
        import os

        out = os.environ['out']
        f = open(out + "/module-${n}.touch", "w")
        f.write("module-${n}");
        f.close()
      '';
    };
  module-1 = mkModule "1";
  module-2 = mkModule "2";
  freecad-customized = freecad.customize {
    modules = [
      module-1
      module-2
    ];
  };
in
runCommand "freecad-test-modules"
  {
    nativeBuildInputs = [ freecad-customized ];
  }
  ''
    mkdir $out
    HOME="$(mktemp -d)" FreeCADCmd --log-file $out/freecad.log -c "sys.exit(0)" </dev/null
    test -f $out/module-1.touch
    test -f $out/module-2.touch
    grep -q 'Initializing ${module-1}... done' $out/freecad.log
    grep -q 'Initializing ${module-2}... done' $out/freecad.log
  ''
