{ lib, writeText, runCommand, python3Full }:
rec {
  pythonJsonToDot = writeText "jstodot" ''
    import sys
    import json
    def dot_notate(obj, target=None, prefix=""):
        if target is None:
            target = {}
        for key, value in obj.items():
            if isinstance(value, dict):
                dot_notate(value, target, prefix + key + ".")
            else:
                target[prefix + key] = value
        return '\n'.join([f"{key}={value}" for key, value in target.items()])
    try:
        print(dot_notate(json.loads(sys.stdin.read())))
    except json.JSONDecodeError as e:
        print(f'Error parsing JSON: {e}', file=sys.stderr)
  '';

  attrToDot = x: builtins.readFile (runCommand "jsonToDot.dot" { } ''
    echo '${builtins.toJSON x}' | ${python3Full}/bin/python ${pythonJsonToDot} > $out
  '');

  compilerEntry = (compilerPkg: compilerName: compilerBinary:
    rec {
      type = compilerName;
      version = "${compilerPkg.version}";
      entry = compilerBinary + "-" + compilerName + "-" + version;
      visibleName = compilerName + " " + version;
      compilerPath = "${compilerPkg}/bin/${compilerBinary}";
    }
  );
  mapCompilerToEntry = (compilerList: compilerName: compilerBinary:
    (map (compilerPkg: compilerEntry compilerPkg compilerName compilerBinary) compilerList)
  );

  ce_configuredCompilersListFromEntries = (entries: builtins.concatStringsSep ":" (map (entry: "${entry.entry}") entries));

  ce_configuredCompilerNameAndBinaryListFromEntries = (prefix: entries: builtins.concatStringsSep "\n" (map
    (entry:
      "${prefix}.${entry.entry}.exe=${entry.compilerPath}"
      + "\n" +
      "${prefix}.${entry.entry}.name=${entry.visibleName}")
    entries));

}
