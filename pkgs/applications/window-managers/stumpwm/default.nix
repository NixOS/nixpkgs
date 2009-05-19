args : 
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  noDepEntry = args.noDepEntry;
  fullDepEntry = args.fullDepEntry;

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

  installation = fullDepEntry (''
    ensureDir $out/bin 
    ensureDir $out/share/stumpwm/doc
    ensureDir $out/share/info 
    ensureDir $out/share/stumpwm/lisp

    cp stumpwm $out/bin
    cp contrib/stumpish $out/bin || true
    cp sample-stumpwmrc.lisp  $out/share/stumpwm/doc
    cp stumpwm.info $out/share/info

    cp -r {.,cl-ppcre}/*.{lisp,fas,lib,asd} contrib $out/share/stumpwm/lisp
    cd $out/share/stumpwm/lisp
    cat << EOF >init-stumpwm.lisp
      (require "asdf") 
      (asdf:operate 'asdf:load-op :cl-ppcre) 
      (asdf:operate 'asdf:load-op :stumpwm)
    EOF
    clisp -K full -i init-stumpwm.lisp
    cat << EOF >init-stumpwm.lisp
      (require "asdf") 
      (asdf:operate 'asdf:load-source-op :cl-ppcre) 
      (asdf:operate 'asdf:load-source-op :stumpwm)
    EOF
    '') ["minInit" "defEnsureDir" "addInputs" "doMake"];

  /* doConfigure should be specified separately */
  phaseNames = ["envVars" "doConfigure" "doMake" "installation"];
      
  name = "${pkgName}-" + version;
  meta = {
    description = "Common Lisp-based ratpoison-like window manager.";
  };
}
