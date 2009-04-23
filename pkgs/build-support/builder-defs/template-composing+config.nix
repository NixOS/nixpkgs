args : with args; let localDefs = builderDefs (args // rec {
                src = /* put a fetchurl here */
                (abort "Specify source");
                useConfig = true;
                reqsList = [
                        ["true" ]
                        ["false"]
                ];
                /* List consisiting of an even number of strings; "key" "value" */
                configFlags = [
                ];
        }) args null; /* null is a terminator for sumArgs */
        in with localDefs;
stdenv.mkDerivation rec {
        name = "${(abort "Specify name")}"+version;
        builder = writeScript (name + "-builder")
                (textClosure localDefs [(abort "Check phases") doMakeInstall doForceShare doPropagate]);
        meta = {
                description = "${(abort "Specify description")}";
                inherit src;
        };
}
