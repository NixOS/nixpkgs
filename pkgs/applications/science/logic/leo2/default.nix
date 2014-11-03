x@{builderDefsPackage
  , ocaml, eprover, zlib
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
    version = "1.6.2";
    name="${baseName}_v${version}";
    url="page.mi.fu-berlin.de/cbenzmueller/leo/leo2_v${version}.tgz";
    hash="d46a94f5991623386eb9061cfb0d748e258359a8c690fded173d35303e0e9e3a";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = "1wjpmizb181iygnd18lx7p77fwaci2clgzs5ix5j51cc8f3pazmv";
  };

  name = "${sourceInfo.baseName}-${sourceInfo.version}";
  inherit buildInputs;

  phaseNames = ["makeInstallationDir" "doUnpack" "doMake" "doFinalize"];

  makeInstallationDir = a.fullDepEntry (''
    mkdir -p "$out/share/leo2/build-dir"
    cd "$out/share/leo2/build-dir"
  '') ["minInit" "defEnsureDir"];

  goSrcDir = "cd src/";

  doFinalize = a.fullDepEntry (''
    mkdir -p "$out/bin"
    echo -e "#! /bin/sh\\n$PWD/../bin/leo --atprc $out/etc/leoatprc \"\$@\"\\n" > "$out/bin/leo"
    chmod a+x "$out/bin/leo"
    mkdir -p "$out/etc"
    echo -e "e = ${eprover}/bin/eprover\\nepclextract = ${eprover}/bin/epclextract" > "$out/etc/leoatprc"
  '') ["minInit" "doMake" "defEnsureDir"];

  makeFlags = [
    "SHELL=${a.stdenv.shell}"
  ];

  meta = {
    description = "A high-performance typed higher order prover";
    maintainers = with a.lib.maintainers;
    [
      raskin
    ];
    platforms = with a.lib.platforms;
      linux;
    license = "BSD";
    inherit (sourceInfo) version;
    homepage = "http://page.mi.fu-berlin.de/cbenzmueller/leo/";
    downloadPage = "http://page.mi.fu-berlin.de/cbenzmueller/leo/download.html";
  };
}) x

