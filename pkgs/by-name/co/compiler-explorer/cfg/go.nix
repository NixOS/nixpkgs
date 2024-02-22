{ utils
, writeText
, defaultGcc
, gccgo13
}:
let


  gocfg = {
    compilers = "&go";
    group.go.compilers = "godefault";
    compiler.godefault.exe = "${gccgo13}/bin/gccgo";
    compiler.godefault.name = "go ${gccgo13.version}";
    defaultCompiler = "godefault";
    objdumper = "${defaultGcc}/bin/objdump";
    supportsBinary = "true";
    binaryHideFuncRe = ''^(_.*|(de)?register_tm_clones|frame_dummy|.*@plt)$'';
    stubRe = ''\bfunc\s+main\b'';
    stubText = "func main() {/*stub provided by Compiler Explorer*/}";

  };

in
writeText "go.defaults.properties" ''
  ${utils.attrToDot gocfg }
''
