{ stdenv, fetchurl, builderDefs }:

let 
  src = fetchurl {
    url = http://www.ladspa.org/ladspa_sdk/ladspa.h.txt;
    sha256 = "1b908csn85ng9sz5s5d1mqk711cmawain2z8px2ajngihdrynb67";
  };
in
  let localDefs = builderDefs.passthru.function {
    buildInputs = [];
    inherit src;
  };
  in with localDefs;
let
  copyFile = fullDepEntry ("
    mkdir -p \$out/include
    cp ${src} \$out/include/ladspa.h
  ") [minInit defEnsureDir];
in
stdenv.mkDerivation {
  name = "ladspa.h";
  builder = writeScript "ladspa.h-builder"
    (textClosure localDefs [copyFile]);
  meta = {
    description = "LADSPA format audio plugins";
    inherit src;
  };
}
