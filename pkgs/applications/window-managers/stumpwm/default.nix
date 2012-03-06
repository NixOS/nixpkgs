args : 
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  noDepEntry = args.noDepEntry;
  fullDepEntry = args.fullDepEntry;

  buildInputs = lib.attrVals ["clisp" "texinfo"] args;
  version = lib.attrByPath ["version"] "0.9.7" args; 

  pkgName = "stumpwm";
in
rec {
  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/stumpwm/${pkgName}-${version}.tgz";
    sha256 = "a0793d22ef90731d34f84e51deafb4bc2095a357c70b9505dc57516f481cdf78";
  };

  inherit buildInputs;
  configureFlags = ["--with-lisp=clisp"];
  envVars = noDepEntry (''
    export HOME="$NIX_BUILD_TOP";
  '');

  installation = fullDepEntry (''
    mkdir -p $out/bin 
    mkdir -p $out/share/stumpwm/doc
    mkdir -p $out/share/info 
    mkdir -p $out/share/stumpwm/lisp

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
    maintainers = [args.lib.maintainers.raskin];
    platforms = with args.lib.platforms;
      linux ++ freebsd;
  };
}
