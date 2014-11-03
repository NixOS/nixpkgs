x@{builderDefsPackage
  , ocaml, eprover
  , ...}:
builderDefsPackage
(a :
let
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="iprover";
    version="0.8.1";
    name="${baseName}_v${version}";
    url="http://${baseName}.googlecode.com/files/${name}.tar.gz";
    hash="15qn523w4l296np5rnkwi50a5x2xqz0kaza7bsh9bkazph7jma7w";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  name = "${sourceInfo.baseName}-${sourceInfo.version}";
  inherit buildInputs;

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMake" "doDeploy"];
  configureCommand = "sh configure";
  doDeploy = a.fullDepEntry (''
    mkdir -p "$out/bin"
    cp iproveropt "$out/bin"

    mkdir -p "$out/share/${name}"
    cp *.p "$out/share/${name}"
    echo -e "#! /bin/sh\\n$out/bin/iproveropt --clausifier \"${eprover}/bin/eprover\" --clausifier_options \" --tstp-format --silent --cnf \" \"\$@\"" > "$out"/bin/iprover
    chmod a+x  "$out"/bin/iprover
  '') ["defEnsureDir" "minInit" "doMake"];

  meta = {
    description = "An automated first-order logic theorem prover";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = with a.lib.licenses;
      gpl3;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://code.google.com/p/iprover/downloads/list";
    };
  };
}) x
