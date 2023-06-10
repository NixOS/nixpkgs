/*
  This module adds the activation script to toplevel, so that any previously
  built configuration can be activated again, as long as they're available in
  the store, e.g. through the profile's older generations.

  Alternate applications of the NixOS modules may omit this module, e.g. to
  build images that are pre-activated and omit the activation script and its
  dependencies.
 */
{ config, lib, pkgs, ... }:

let
  inherit (lib)
    optionalString
    ;
in
{
  config = {
    system.systemBuilderArgs = {
      activationScript = config.system.activationScripts.script;
      dryActivationScript = config.system.dryActivationScript;
      localeArchive = "${config.i18n.glibcLocales}/lib/locale/locale-archive";
      distroId = config.system.nixos.distroId;
      perl = pkgs.perl.withPackages (p: with p; [ ConfigIniFiles FileSlurp ]);
    };

    system.systemBuilderCommands = ''
      echo "$activationScript" > $out/activate
      echo "$dryActivationScript" > $out/dry-activate
      substituteInPlace $out/activate --subst-var out
      substituteInPlace $out/dry-activate --subst-var out
      chmod u+x $out/activate $out/dry-activate
      unset activationScript dryActivationScript

      mkdir $out/bin
      substituteAll ${./switch-to-configuration.pl} $out/bin/switch-to-configuration
      chmod +x $out/bin/switch-to-configuration
      ${optionalString (pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform) ''
        if ! output=$($perl/bin/perl -c $out/bin/switch-to-configuration 2>&1); then
          echo "switch-to-configuration syntax is not valid:"
          echo "$output"
          exit 1
        fi
      ''}
    '';
  };
}
