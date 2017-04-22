{ stdenv, lib, bash }:

let unameTuple = [
    /* kernel-name */       "Linux"
    /* node-name */         "localhost"
    /* kernel-release */    "4.4.0-not-a-real-version"
    /* kernel-version */    "#1 SMP PREEMPT Thu Jan  1 00:00:01 GMT 1970"
    /* machine */           (builtins.head (lib.splitString "-" stdenv.system))
    /* processor */         "unknown"
    /* hardware-platform */ "unknown"
    /* operating-system */  "GNU/Linux"
  ];
in

stdenv.mkDerivation {
  name = "fake-uname";
  buildCommand = ''
    mkdir -p $out/bin
    substitute ${./fake-uname.sh} $out/bin/uname \
      --subst-var-by shell "${bash}/bin/bash" \
      --subst-var-by unameTuple '${lib.concatStringsSep " " (map (x: "\"${x}\"") unameTuple)}'
    chmod a+x $out/bin/uname
  '';
}
