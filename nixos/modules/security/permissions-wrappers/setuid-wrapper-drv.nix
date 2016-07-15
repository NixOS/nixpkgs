{ config, lib, pkgs, ... }:

let  
     cfg = config.security.permissionsWrappers;

     # Produce a shell-code splice intended to be stitched into one of
     # the build or install phases within the derivation.
     mkSetuidWrapper = { program, source ? null, ...}:
       ''
         if ! source=${if source != null then source else "$(readlink -f $(PATH=$PERMISSIONS_WRAPPER_PATH type -tP ${program}))"}; then
             # If we can't find the program, fall back to the
             # system profile.
             source=/nix/var/nix/profiles/default/bin/${program}
         fi

         gcc -Wall -O2 -DWRAPPER_SETUID=1 -DSOURCE_PROG=\"$source\" -DWRAPPER_DIR=\"${cfg.permissionsWrapperDir}\" \
             -lcap-ng -lcap ${./permissions-wrapper.c} -o $out/bin/${program}.wrapper
       '';
in

# This is only useful for Linux platforms and a kernel version of
# 4.3 or greater
assert pkgs.stdenv.isLinux;
assert lib.versionAtLeast (lib.getVersion config.boot.kernelPackages.kernel) "4.3";

pkgs.stdenv.mkDerivation {
  name         = "setuid-wrapper";
  unpackPhase  = "true";
  installPhase = ''
    mkdir -p $out/bin

    # Concat together all of our shell splices to compile
    # binary wrapper programs for all configured setcap programs.
    ${concatMapStrings mkSetuidWrapper cfg.setuid}
  '';
};
