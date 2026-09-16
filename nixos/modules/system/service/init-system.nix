# Selects the service management backend for modular services
# (`system.services`, see the modular services documentation).
#
# The default is systemd, which keeps the behavior of existing NixOS
# configurations exactly as it is today. The alternative backends (dinit,
# runit, s6) only affect how `system.services` is translated; everything
# else, including `systemd.services`, `systemd.*` and `environment.etc`, is
# untouched. They are experimental.
#
# The backend modules themselves (dinit/, runit/, s6/, systemd/) are always
# imported by module-list.nix; each of them activates its translation via
# `config = lib.mkIf (config.system.initSystem == "...") { ... }`, which is
# the idiomatic way to make module behavior depend on configuration.
{
  lib,
  ...
}:
{
  _class = "nixos";

  options.system.initSystem = lib.mkOption {
    type = lib.types.enum [
      "systemd"
      "dinit"
      "runit"
      "s6"
      "rc.d"
    ];
    default = "systemd";
    description = ''
      Service management backend used to translate modular services
      (`system.services`) into a concrete init system configuration.

      This option only affects `system.services`. It does not change how
      `systemd.services`, `systemd.*` or any other existing NixOS option
      behaves.
    '';
  };
}