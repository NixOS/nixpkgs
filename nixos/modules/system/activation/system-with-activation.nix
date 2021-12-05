{ config, lib, pkgs, ... }:
{
  config = {
    system.systemBuilderAttrs = {
      activationScript = config.system.activationScripts.script;
      dryActivationScript = config.system.dryActivationScript;
    };

    system.systemBuilderCommands = ''
      echo "$activationScript" > $out/activate
      echo "$dryActivationScript" > $out/dry-activate
      substituteInPlace $out/activate --subst-var out
      substituteInPlace $out/dry-activate --subst-var out
      chmod u+x $out/activate $out/dry-activate
      unset activationScript dryActivationScript
      ${pkgs.stdenv.shell} -n $out/activate
      ${pkgs.stdenv.shell} -n $out/dry-activate

      mkdir -p $out/bin
      export localeArchive="${config.i18n.glibcLocales}/lib/locale/locale-archive"
      substituteAll ${./switch-to-configuration.pl} $out/bin/switch-to-configuration
      chmod +x $out/bin/switch-to-configuration
      ${lib.optionalString (pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform) ''
        if ! output=$($perl/bin/perl -c $out/bin/switch-to-configuration 2>&1); then
          echo "switch-to-configuration syntax is not valid:"
          echo "$output"
          exit 1
        fi
      ''}
    '';
  };
}
