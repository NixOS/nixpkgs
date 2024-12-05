# Xen Project Hypervisor EFI support.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (builtins) readFile;
  inherit (lib)
    getExe
    literalExpression
    mkIf
    mkOption
    mkRenamedOptionModule
    optionals
    types
    ;
  inherit (types)
    enum
    path
    listOf
    str
    ;

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
      ++ optionals (cfg.boot.builderVerbosity == "info") (
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
  imports = [
    (mkRenamedOptionModule
      [
        "virtualisation"
        "xen"
        "efi"
        "bootBuilderVerbosity"
      ]
      [
        "virtualisation"
        "xen"
        "boot"
        "builderVerbosity"
      ]
    )
    (mkRenamedOptionModule
      [
        "virtualisation"
        "xen"
        "bootParams"
      ]
      [
        "virtualisation"
        "xen"
        "boot"
        "params"
      ]
    )
    (mkRenamedOptionModule
      [
        "virtualisation"
        "xen"
        "efi"
        "path"
      ]
      [
        "virtualisation"
        "xen"
        "boot"
        "efi"
        "path"
      ]
    )
  ];

  ## Interface ##

  options.virtualisation.xen.boot = {
    params = mkOption {
      default = [ ];
      example = ''
        [
          "iommu=force:true,qinval:true,debug:true"
          "noreboot=true"
          "vga=ask"
        ]
      '';
      type = listOf str;
      description = ''
        Xen Command Line parameters passed to Domain 0 at boot time.
        Note: these are different from `boot.kernelParams`. See
        the [Xen documentation](https://xenbits.xenproject.org/docs/unstable/misc/xen-command-line.html) for more information.
      '';
    };
    builderVerbosity = mkOption {
      type = enum [
        "default"
        "info"
        "debug"
        "quiet"
      ];
      default = "default";
      example = "info";
      description = ''
        The boot entry builder script should be called with exactly one of the following arguments in order to specify its verbosity:

        - `quiet` supresses all messages.

        - `default` adds a simple "Installing Xen Project Hypervisor boot entries...done." message to the script.

        - `info` is the same as `default`, but it also prints a diff with information on which generations were altered.
          - This option adds two extra dependencies to the script: `diffutils` and `bat`.

        - `debug` prints information messages for every single step of the script.

        This option does not alter the actual functionality of the script, just the number of messages printed when rebuilding the system.
      '';
    };
    bios = {
      path = mkOption {
        type = path;
        default = "${cfg.package.boot}/${cfg.package.multiboot}";
        defaultText = literalExpression "\${config.virtualisation.xen.package.boot}/\${config.virtualisation.xen.package.multiboot}";
        example = literalExpression "\${config.virtualisation.xen.package}/boot/xen-\${config.virtualisation.xen.package.version}";
        description = ''
          Path to the Xen `multiboot` binary used for BIOS booting.
          Unless you're building your own Xen derivation, you should leave this
          option as the default value.
        '';
      };
    };
    efi = {
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
  };

  ## Implementation ##

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion =
          config.boot.loader.systemd-boot.enable
          || (config.boot ? lanzaboote) && config.boot.lanzaboote.enable
          || config.boot.loader.limine.enable;
        message = "Xen only supports booting on systemd-boot, Lanzaboote or Limine.";
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
      # fetch the dom0 kernel paths and access the `cfg.boot.params` option.
      bootspec.extensions = {
        # Bootspec extension v1 is deprecated, and will be removed in 26.05
        # It is present for backwards compatibility
        "org.xenproject.bootspec.v1" = {
          xen = cfg.boot.efi.path;
          xenParams = cfg.boot.params;
        };
        # Bootspec extension v2 includes more detail,
        # including supporting multiboot, and is the current supported
        # bootspec extension
        "org.xenproject.bootspec.v2" = {
          efiPath = cfg.boot.efi.path;
          multibootPath = cfg.boot.bios.path;
          version = cfg.package.version;
          params = cfg.boot.params;
        };
      };

      # See the `xenBootBuilder` script in the main `let...in` statement of this file.
      loader.systemd-boot.extraInstallCommands = ''
        ${getExe xenBootBuilder} ${cfg.boot.builderVerbosity}
      '';
    };
  };
}
