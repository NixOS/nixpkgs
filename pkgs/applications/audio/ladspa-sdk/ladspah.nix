{ runCommand, fetchurl }:

let

  src = fetchurl {
    url = http://www.ladspa.org/ladspa_sdk/ladspa.h.txt;
    sha256 = "1b908csn85ng9sz5s5d1mqk711cmawain2z8px2ajngihdrynb67";
  };

in

runCommand "ladspa.h"
  { meta.description = "LADSPA format audio plugins"; }
  ''
    mkdir -p $out/include
    cp ${src} $out/include/ladspa.h
  ''
