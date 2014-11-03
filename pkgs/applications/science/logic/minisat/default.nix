x@{builderDefsPackage
  , zlib
  , ...}:
builderDefsPackage
(a :
let
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="minisat";
    version="2.2.0";
    name="${baseName}-${version}";
    url="http://minisat.se/downloads/${name}.tar.gz";
    hash="023qdnsb6i18yrrawlhckm47q8x0sl7chpvvw3gssfyw3j2pv5cj";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["setVars" "doMake" "doDeploy"];
  goSrcDir = "cd simp";
  doDeploy = a.fullDepEntry (''
    mkdir -p "$out"/bin
    cp minisat_static "$out/bin"/minisat
  '') ["minInit" "defEnsureDir"];
  makeFlags = ["rs"];
  setVars = a.fullDepEntry (''
    export MROOT=$PWD/../
  '') ["doUnpack"];

  meta = {
    description = "A compact and readable SAT-solver";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = a.stdenv.lib.licenses.mit;
    homepage = "http://minisat.se/";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://minisat.se/MiniSat.html";
    };
  };
}) x
