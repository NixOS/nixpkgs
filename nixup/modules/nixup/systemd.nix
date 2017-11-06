{ config, lib, pkgs, utils, ... }:

let
  config_ = {
    systemd = config.systemd // { user = config.user; };
  };

  wrapper = import ../../../nixos/modules/system/boot/systemd.nix { config=config_; inherit lib pkgs utils; };

  systemd-lib = import ../../../nixos/modules/system/boot/systemd-lib.nix { config=config_; inherit lib pkgs; };
in

{
  options = {
    systemd = { inherit (wrapper.options.systemd) package packages defaultUnit ctrlAltDelUnit globalEnvironment; };

    user = wrapper.options.systemd.user;
  };

  config = {
    nixup.buildCommands = ''
      ln -s ${config.nixup.build.systemd} $out/systemd
    '';

    nixup.build.systemd = systemd-lib.generateUnits "user" config.user.units [] [];

    user = { inherit (wrapper.config.systemd.user) units timers; };
  };
}
