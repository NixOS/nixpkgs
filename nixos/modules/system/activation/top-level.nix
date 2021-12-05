{ config, lib, pkgs, extendModules, noUserModules, ... }:

with lib;

let
  systemBuilder =
    ''
      mkdir $out

      ln -s ${config.system.build.etc}/etc $out/etc
      ln -s ${config.system.path} $out/sw

      echo -n "$configurationName" > $out/configuration-name
      echo -n "$nixosLabel" > $out/nixos-version

      echo -n "${toString config.system.extraDependencies}" > $out/extra-dependencies

      ${config.system.systemBuilderCommands}

      ${config.system.extraSystemBuilderCmds}
    '';

  # Putting it all together.  This builds a store path containing
  # symlinks to the various parts of the built configuration (the
  # kernel, systemd units, init scripts, etc.) as well as a script
  # `switch-to-configuration' that activates the configuration and
  # makes it bootable.
  baseSystem = pkgs.stdenvNoCC.mkDerivation ({
    name = "nixos-system-${config.system.name}-${config.system.nixos.label}";
    preferLocalBuild = true;
    allowSubstitutes = false;
    buildCommand = systemBuilder;

    inherit (pkgs) coreutils;
    systemd = config.systemd.package;
    shell = "${pkgs.bash}/bin/sh";
    su = "${pkgs.shadow.su}/bin/su";
    utillinux = pkgs.util-linux;

    kernelParams = config.boot.kernelParams;
    installBootLoader =
      config.system.build.installBootLoader
      or "echo 'Warning: do not know how to make this configuration bootable; please enable a boot loader.' 1>&2; true";
    nixosLabel = config.system.nixos.label;

    configurationName = config.boot.loader.grub.configurationName;

    # Needed by switch-to-configuration.
    perl = pkgs.perl.withPackages (p: with p; [ FileSlurp NetDBus XMLParser XMLTwig ]);
  } // config.system.systemBuilderAttrs);

  # Handle assertions and warnings

  failedAssertions = map (x: x.message) (filter (x: !x.assertion) config.assertions);

  baseSystemAssertWarn = if failedAssertions != []
    then throw "\nFailed assertions:\n${concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
    else showWarnings config.warnings baseSystem;

  # Replace runtime dependencies
  system = foldr ({ oldDependency, newDependency }: drv:
      pkgs.replaceDependency { inherit oldDependency newDependency drv; }
    ) baseSystemAssertWarn config.system.replaceRuntimeDependencies;

in

{
  imports = [
    (mkRemovedOptionModule [ "nesting" "clone" ] "Use `specialisation.«name» = { inheritParentConfig = true; configuration = { ... }; }` instead.")
    (mkRemovedOptionModule [ "nesting" "children" ] "Use `specialisation.«name».configuration = { ... }` instead.")
    ../build.nix
  ];

  options = {

    system.copySystemConfiguration = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, copies the NixOS configuration file
        (usually <filename>/etc/nixos/configuration.nix</filename>)
        and links it from the resulting system
        (getting to <filename>/run/current-system/configuration.nix</filename>).
        Note that only this single file is copied, even if it imports others.
      '';
    };

    system.systemBuilderCommands = mkOption {
      type = types.lines;
      internal = true;
      default = "";
      description = ''
        This code will be added to the builder creating the system store path.
      '';
    };

    system.systemBuilderAttrs = mkOption {
      type = types.attrsOf types.unspecified;
      internal = true;
      default = {};
      description = ''
        Derivation attributes that will be passed to the top level system builder.
      '';
    };

    system.extraSystemBuilderCmds = mkOption {
      type = types.lines;
      internal = true;
      default = "";
      description = ''
        This code will be added to the builder creating the system store path.
      '';
    };

    system.extraDependencies = mkOption {
      type = types.listOf types.package;
      default = [];
      description = ''
        A list of packages that should be included in the system
        closure but not otherwise made available to users. This is
        primarily used by the installation tests.
      '';
    };

    system.replaceRuntimeDependencies = mkOption {
      default = [];
      example = lib.literalExpression "[ ({ original = pkgs.openssl; replacement = pkgs.callPackage /path/to/openssl { }; }) ]";
      type = types.listOf (types.submodule (
        { ... }: {
          options.original = mkOption {
            type = types.package;
            description = "The original package to override.";
          };

          options.replacement = mkOption {
            type = types.package;
            description = "The replacement package.";
          };
        })
      );
      apply = map ({ original, replacement, ... }: {
        oldDependency = original;
        newDependency = replacement;
      });
      description = ''
        List of packages to override without doing a full rebuild.
        The original derivation and replacement derivation must have the same
        name length, and ideally should have close-to-identical directory layout.
      '';
    };

    system.name = mkOption {
      type = types.str;
      default =
        if config.networking.hostName == ""
        then "unnamed"
        else config.networking.hostName;
      defaultText = literalExpression ''
        if config.networking.hostName == ""
        then "unnamed"
        else config.networking.hostName;
      '';
      description = ''
        The name of the system used in the <option>system.build.toplevel</option> derivation.
        </para><para>
        That derivation has the following name:
        <literal>"nixos-system-''${config.system.name}-''${config.system.nixos.label}"</literal>
      '';
    };

  };


  config = {

    system.extraSystemBuilderCmds =
      optionalString
        config.system.copySystemConfiguration
        ''ln -s '${import ../../../lib/from-env.nix "NIXOS_CONFIG" <nixos-config>}' \
            "$out/configuration.nix"
        '';

    system.build.toplevel = system;

  };

}
