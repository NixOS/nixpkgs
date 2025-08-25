# Xen Project Hypervisor EFI support.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    getExe
    literalExpression
    mkIf
    mkOption
    optionals
    readFile
    types
    ;
  inherit (types) enum path;

  cfg = config.virtualisation.xen;

  xenBootBuilder = pkgs.writeShellApplication {
    name = "xenBootBuilder";
    runtimeInputs =
      (with pkgs; [
        binutils
        coreutils
        findutils
        gawk
        gnugrep
        gnused
        jq
      ])
      ++ optionals (cfg.efi.bootBuilderVerbosity == "info") (
        with pkgs;
        [
          bat
          diffutils
        ]
      );
    runtimeEnv = {
      efiMountPoint = config.boot.loader.efi.efiSysMountPoint;
    };

    # We disable SC2016 because we don't want to expand the regexes in the sed commands.
    excludeShellChecks = [ "SC2016" ];

    text = readFile ./boot-builder.sh;
  };
in
{
  ## Interface ##

  options.virtualisation.xen.efi = {
    bootBuilderVerbosity = mkOption {
      type = enum [
        "default"
        "info"
        "debug"
        "quiet"
      ];
      default = "default";
      example = "info";
      description = ''
        The EFI boot entry builder script should be called with exactly one of the following arguments in order to specify its verbosity:

        - `quiet` supresses all messages.

        - `default` adds a simple "Installing Xen Project Hypervisor boot entries...done." message to the script.

        - `info` is the same as `default`, but it also prints a diff with information on which generations were altered.
          - This option adds two extra dependencies to the script: `diffutils` and `bat`.

        - `debug` prints information messages for every single step of the script.

        This option does not alter the actual functionality of the script, just the number of messages printed when rebuilding the system.
      '';
    };

    path = mkOption {
      type = path;
      default = "${cfg.package.boot}/${cfg.package.efi}";
      defaultText = literalExpression "\${config.virtualisation.xen.package.boot}/\${config.virtualisation.xen.package.efi}";
      example = literalExpression "\${config.virtualisation.xen.package}/boot/efi/efi/nixos/xen-\${config.virtualisation.xen.package.version}.efi";
      description = ''
        Path to xen.efi. `pkgs.xen` is patched to install the xen.efi file
        on `$boot/boot/xen.efi`, but an unpatched Xen build may install it
        somewhere else, such as `$out/boot/efi/efi/nixos/xen.efi`. Unless
        you're building your own Xen derivation, you should leave this
        option as the default value.
      '';
    };
  };

  ## Implementation ##

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion =
          config.boot.loader.systemd-boot.enable
          || (config.boot ? lanzaboote) && config.boot.lanzaboote.enable;
        message = "Xen only supports booting on systemd-boot or Lanzaboote.";
      }
      {
        assertion = config.boot.initrd.systemd.enable;
        message = "Xen does not support the legacy script-based Stage 1 initrd.";
      }
    ];
    warnings = lib.optional ((config.boot ? lanzaboote) && config.boot.lanzaboote.enable) ''
      Xen support has not yet been merged into Lanzaboote.
      Ensure that your Lanzaboote configuration includes PR #387
      https://github.com/nix-community/lanzaboote/pull/387
    '';
    boot = {
      # Xen Bootspec extension. This extension allows NixOS bootloaders to
      # fetch the `xen.efi` path and access the `cfg.bootParams` option.
      bootspec.extensions = {
        "org.xenproject.bootspec.v1" = {
          xen = cfg.efi.path;
          xenParams = cfg.bootParams;
        };
      };

      # See the `xenBootBuilder` script in the main `let...in` statement of this file.
      loader.systemd-boot.extraInstallCommands = ''
        ${getExe xenBootBuilder} ${cfg.efi.bootBuilderVerbosity}
      '';
    };
  };
}
