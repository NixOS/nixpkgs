{ config, lib, pkgs, ... }:

with lib;

{

  config = {

    nixup.buildCommands = ''
      mkdir -p $out/bin
      export perl="${pkgs.perl}/bin/perl -I${pkgs.perlPackages.FileSlurp}/lib/perl5/site_perl";
      export coreutils=${pkgs.coreutils}
      export systemd=${config.systemd.package}
      export flavour='nixup'
      export installBootLoader='/dev/null'
      export utillinux='/dev/null'
      substituteAll ${../../../nixos/modules/system/activation/switch-to-configuration.pl} $out/bin/switch-to-configuration
      chmod +x $out/bin/switch-to-configuration
    '';

    nixup.activationScripts.resourceFiles = ''
      echo "Setting up systemd user services ..."
      mkdir -p ''${XDG_RUNTIME_DIR:-/run/user/$(id -u $USER)}/systemd
      if [ ! -L "''${XDG_RUNTIME_DIR:-/run/user/$(id -u $USER)}/systemd/user" ]; then
          ln -sf $NIXUP_RUNTIME_DIR/active-profile/systemd ''${XDG_RUNTIME_DIR:-/run/user/$(id -u $USER)}/systemd/user
      fi
    '';

  };

}
