{ config, lib, ... }:
let
  cfg = config.system.nixos;
in

{

  options.system = {

    nixos.bootEntryLabel = lib.mkOption {
      type = lib.types.str;
      description = ''
        Display label of the boot menu entry.

        If you only want to modify the version part of the boot entry label
        use {option}`system.nixos.label` instead.

        In the label the string `{generation}` is replaced by the generation
        number and `{build_date}` is replaced by the date the configuration
        was built.  (Since Nix expressions are pure, these cannot be filled
        in by Nix like the kernel version.)

        The default entry label is
        ```
        Generation {generation} ''${config.system.nixos.distroName} ''${config.system.nixos.codeName} ''${config.system.nixos.label} (Linux ''${config.boot.kernelPackages.kernel.modDirVersion}), built on {build_date}
        ```
        and looks like
        ```
        Generation 1234 NixOS Emu 16.03.1160.f2d4ee1 (Linux 28.12.69), built on 2016-03-14
        ```

        Can be overridden by setting {env}`NIXOS_BOOT_ENTRY_LABEL`.

        Useful for not loosing track of configurations built from different
        nixos branches/revisions, e.g.:

        ```
        #!/bin/sh
        today=`date +%Y%m%d`
        branch=`(cd nixpkgs ; git branch 2>/dev/null | sed -n '/^\* / { s|^\* ||; p; }')`
        revision=`(cd nixpkgs ; git rev-parse HEAD)`
        export NIXOS_BOOT_ENTRY_LABEL="{generation}. NixOS $today.$branch-''${revision:0:7}"
        nixos-rebuild switch
        ```

        Note: Only used by boot loaders which follow the Bootspec RFC
        [RFC 0125].

        [RFC 0125]: https://github.com/NixOS/rfcs/blob/master/rfcs/0125-bootspec.md
      '';
    };

    nixos.label = lib.mkOption {
      type = lib.types.strMatching "[a-zA-Z0-9:_\\.-]*";
      description = ''
        NixOS version name to be used in the names of generated
        outputs and boot labels.

        If you ever wanted to influence the labels in your GRUB menu,
        this is the option for you.  For more control over the label
        use option {option}`system.nixos.bootEntryLabel`.

        It can only contain letters, numbers and the following symbols:
        `:`, `_`, `.` and `-`.

        The default is {option}`system.nixos.tags` separated by
        "-" + "-" + {env}`NIXOS_LABEL_VERSION` environment
        variable (defaults to the value of
        {option}`system.nixos.version`).

        Can be overridden by setting {env}`NIXOS_LABEL`.

        Useful for not loosing track of configurations built from different
        nixos branches/revisions, e.g.:

        ```
        #!/bin/sh
        today=`date +%Y%m%d`
        branch=`(cd nixpkgs ; git branch 2>/dev/null | sed -n '/^\* / { s|^\* ||; p; }')`
        revision=`(cd nixpkgs ; git rev-parse HEAD)`
        export NIXOS_LABEL_VERSION="$today.$branch-''${revision:0:7}"
        nixos-rebuild switch
        ```
      '';
    };

    nixos.tags = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "with-xen" ];
      description = ''
        Strings to prefix to the default
        {option}`system.nixos.label`.

        Useful for not losing track of configurations built with
        different options, e.g.:

        ```
        {
          system.nixos.tags = [ "with-xen" ];
          virtualisation.xen.enable = true;
        }
        ```
      '';
    };

  };

  config = {
    # This is set here rather than up there so that changing it would
    # not rebuild the manual
    system.nixos.label = lib.mkDefault (
      lib.maybeEnv "NIXOS_LABEL" (
        lib.concatStringsSep "-" (
          (lib.sort (x: y: x < y) cfg.tags) ++ [ (lib.maybeEnv "NIXOS_LABEL_VERSION" cfg.version) ]
        )
      )
    );
    system.nixos.bootEntryLabel = lib.mkDefault (
      lib.maybeEnv "NIXOS_BOOT_ENTRY_LABEL" "Generation {generation} ${config.system.nixos.distroName} ${config.system.nixos.codeName} ${config.system.nixos.label} (Linux ${config.boot.kernelPackages.kernel.modDirVersion}), built on {build_date}"
    );
  };
}
