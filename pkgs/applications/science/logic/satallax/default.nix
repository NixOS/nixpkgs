x@{builderDefsPackage
  , sbcl, zlib
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="satallax";
    version="1.4";
    name="${baseName}-${version}";
    url="http://www.ps.uni-saarland.de/~cebrown/satallax/downloads/${name}.tar.gz";
    hash="0l8dq4nyfw2bdsyqmgb4v6fjw3739p8nqv4bh2gh2924ibzrq5fc";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["doDeployMinisat" "doDeploy"];

  doDeployMinisat = a.fullDepEntry (''
    (
      cd minisat/simp
      make
    )

    mkdir -p "$out/bin"
    cp minisat/simp/minisat "$out/bin"

    echo "(setq *minisat-binary* \"$out/bin/minisat\")" > config.lisp

  '') ["defEnsureDir" "minInit" "addInputs" "doUnpack"];
  doDeploy = a.fullDepEntry (''
    mkdir -p "$out/share/satallax/build-dir"
    cp -r * "$out/share/satallax/build-dir"
    cd  "$out/share/satallax/build-dir"

    sbcl --load make.lisp
    ! ( ./test | grep ERROR )
    
    mkdir -p "$out/bin"
    cp bin/satallax "$out/bin"
  '') ["defEnsureDir" "minInit" "addInputs" "doUnpack"];
      
  meta = {
    description = "A higher-order logic prover";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      unix;
    license = "free-noncopyleft";
    homepage = "http://www.ps.uni-saarland.de/~cebrown/satallax/";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.ps.uni-saarland.de/~cebrown/satallax/";
    };
  };
}) x

