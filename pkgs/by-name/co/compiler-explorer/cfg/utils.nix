{ lib, writeText, runCommand, python3Full }:
rec {
  attrToDot =
    let
      attrToDotHelper = prefix: x:
        lib.concatStrings
          (lib.mapAttrsToList
            (k: v:
              if builtins.elem (builtins.typeOf v) [ "string" "int" "float" ]
              then "${prefix}${k}=${toString v}\n"
              else attrToDotHelper "${prefix}${k}." v)
            x);
    in
    attrToDotHelper "";

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

  ce_configuredCompilerNameAndBinaryListFromEntries =
    prefix: lib.concatMapStrings
      (entry:
        attrToDot {
          ${prefix}.${entry.entry} = {
            exe = entry.compilerPath;
            name = entry.visibleName;
          };
        });

}
