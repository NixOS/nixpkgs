x@{builderDefsPackage
  , ocaml, eprover
  , ...}:
builderDefsPackage
(a :  
let 
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++ 
    ["eprover"];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    baseName="leo2";
    version="1.2.6";
    name="${baseName}_v${version}";
    url="http://www.ags.uni-sb.de/~leo/${name}.tgz";
    hash="0gjgcm6nb9kzdl0y72sgvf2w2q92s1ix70lh6wjz9lj2qdf7gi1z";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  inherit (sourceInfo) name version;
  inherit buildInputs;

  phaseNames = ["makeInstallationDir" "doUnpack" "doMake" "doFinalize"];

  makeInstallationDir = a.fullDepEntry (''
    ensureDir "$out/share/leo2/build-dir"
    cd "$out/share/leo2/build-dir"
  '') ["minInit" "defEnsureDir"];

  goSrcDir = "cd src/";

  doFinalize = a.fullDepEntry (''
    ensureDir "$out/bin"
    echo -e "#! /bin/sh\\n$PWD/../bin/leo --atprc $out/etc/leoatprc \"\$@\"\\n" > "$out/bin/leo"
    chmod a+x "$out/bin/leo"
    ensureDir "$out/etc"
    echo -e "e = ${eprover}/bin/eprover\\nepclextract = ${eprover}/bin/epclextract" > "$out/etc/leoatprc"
  '') ["minInit" "doMake" "defEnsureDir"];

  meta = {
    description = "A high-performance typed higher order prover";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "BSD";
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://www.ags.uni-sb.de/~leo/download.html";
    };
  };
}) x

