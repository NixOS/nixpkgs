args : 
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  noDepEntry = args.noDepEntry;
  FullDepEntry = args.FullDepEntry;

  buildInputs = lib.attrVals ["clisp" "texinfo"] args;
  version = lib.getAttr ["version"] "0.9.4.1" args; 

  pkgName = "stumpwm";
in
rec {
  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/stumpwm/${pkgName}-${version}.tgz";
    sha256 = "0wnkv3bgaj2bflh795ph6wiyhxzbhrif20vb40j6hjxxs9kywzqj";
  };

  inherit buildInputs;
  configureFlags = ["--with-lisp=clisp"];
  envVars = noDepEntry (''
    export HOME="$NIX_BUILD_TOP";
  '');

  installation = FullDepEntry (''
    ensureDir $out/bin 
    ensureDir $out/share/stumpwm/doc
    ensureDir $out/share/info 

    cp stumpwm $out/bin
    cp sample-stumpwmrc.lisp  $out/share/stumpwm/doc
    cp stumpwm.info $out/share/info
  '') ["minInit" "defEnsureDir" "addInputs" "doMake"];

  /* doConfigure should be specified separately */
  phaseNames = ["envVars" "doConfigure" "doMake" "installation"];
      
  name = "${pkgName}-" + version;
  meta = {
    description = "Common Lisp-based ratpoison-like window manager.";
  };
}
