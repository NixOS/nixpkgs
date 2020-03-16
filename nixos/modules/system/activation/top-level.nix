{ config, lib, pkgs, modules, baseModules, ... }:

with lib;

let


  # This attribute is responsible for creating boot entries for
  # child configuration. They are only (directly) accessible
  # when the parent configuration is boot default. For example,
  # you can provide an easy way to boot the same configuration
  # as you use, but with another kernel
  # !!! fix this
  cloner = inheritParent: list:
    map (childConfig:
      (import ../../../lib/eval-config.nix {
        inherit baseModules;
        system = config.nixpkgs.initialSystem;
        modules =
           (optionals inheritParent modules)
        ++ [ ./no-clone.nix ]
        ++ [ childConfig ];
      }).config.system.build.toplevel
    ) list;

  children =
     cloner false config.nesting.children
  ++ cloner true config.nesting.clone;

  systemBuilder =
    let
      kernelPath = "${config.boot.kernelPackages.kernel}/" +
        "${config.system.boot.loader.kernelFile}";
      initrdPath = "${config.system.build.initialRamdisk}/" +
        "${config.system.boot.loader.initrdFile}";
    in ''
      mkdir $out

      # Containers don't have their own kernel or initrd.  They boot
      # directly into stage 2.
      ${optionalString (!config.boot.isContainer) ''
        if [ ! -f ${kernelPath} ]; then
          echo "The bootloader cannot find the proper kernel image."
          echo "(Expecting ${kernelPath})"
          false
        fi

        ln -s ${kernelPath} $out/kernel
        ln -s ${config.system.modulesTree} $out/kernel-modules
        ${optionalString (config.hardware.deviceTree.package != null) ''
          ln -s ${config.hardware.deviceTree.package} $out/dtbs
        ''}

        echo -n "$kernelParams" > $out/kernel-params

        ln -s ${initrdPath} $out/initrd

        ln -s ${config.system.build.initialRamdiskSecretAppender}/bin/append-initrd-secrets $out

        ln -s ${config.hardware.firmware}/lib/firmware $out/firmware
      ''}

      echo "$activationScript" > $out/activate
      substituteInPlace $out/activate --subst-var out
      chmod u+x $out/activate
      unset activationScript

      cp ${config.system.build.bootStage2} $out/init
      substituteInPlace $out/init --subst-var-by systemConfig $out

      ln -s ${config.system.build.etc}/etc $out/etc
      ln -s ${config.system.path} $out/sw
      ln -s "$systemd" $out/systemd

      echo -n "$configurationName" > $out/configuration-name
      echo -n "systemd ${toString config.systemd.package.interfaceVersion}" > $out/init-interface-version
      echo -n "$nixosLabel" > $out/nixos-version
      echo -n "${pkgs.stdenv.hostPlatform.system}" > $out/system

      mkdir $out/fine-tune
      childCount=0
      for i in $children; do
        childCount=$(( childCount + 1 ))
        ln -s $i $out/fine-tune/child-$childCount
      done

      mkdir $out/bin
      export localeArchive="${config.i18n.glibcLocales}/lib/locale/locale-archive"
      substituteAll ${./switch-to-configuration.pl} $out/bin/switch-to-configuration
      chmod +x $out/bin/switch-to-configuration

      echo -n "${toString config.system.extraDependencies}" > $out/extra-dependencies

      ${config.system.extraSystemBuilderCmds}
    '';

  # Putting it all together.  This builds a store path containing
  # symlinks to the various parts of the built configuration (the
  # kernel, systemd units, init scripts, etc.) as well as a script
  # `switch-to-configuration' that activates the configuration and
  # makes it bootable.
  baseSystem = pkgs.stdenvNoCC.mkDerivation {
    name = let hn = config.networking.hostName;
               nn = if (hn != "") then hn else "unnamed";
        in "nixos-system-${nn}-${config.system.nixos.label}";
    preferLocalBuild = true;
    allowSubstitutes = false;
    buildCommand = systemBuilder;

    inherit (pkgs) utillinux coreutils;
    systemd = config.systemd.package;
    shell = "${pkgs.bash}/bin/sh";
    su = "${pkgs.shadow.su}/bin/su";

    inherit children;
    kernelParams = config.boot.kernelParams;
    installBootLoader =
      config.system.build.installBootLoader
      or "echo 'Warning: do not know how to make this configuration bootable; please enable a boot loader.' 1>&2; true";
    activationScript = config.system.activationScripts.script;
    nixosLabel = config.system.nixos.label;

    configurationName = config.boot.loader.grub.configurationName;

    # Needed by switch-to-configuration.

    perl = "${pkgs.perl}/bin/perl " + (concatMapStringsSep " " (lib: "-I${lib}/${pkgs.perl.libPrefix}") (with pkgs.perlPackages; [ FileSlurp NetDBus XMLParser XMLTwig ]));
  };

  # Handle assertions and warnings

  failedAssertions = map (x: x.message) (filter (x: !x.assertion) config.assertions);

  baseSystemAssertWarn = if failedAssertions != []
    then throw "\nFailed assertions:\n${concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
    else showWarnings config.warnings baseSystem;

  # Replace runtime dependencies
  system = fold ({ oldDependency, newDependency }: drv:
      pkgs.replaceDependency { inherit oldDependency newDependency drv; }
    ) baseSystemAssertWarn config.system.replaceRuntimeDependencies;

in

{
  options = {

    system.build = mkOption {
      internal = true;
      default = {};
      type = types.attrs;
      description = ''
        Attribute set of derivations used to setup the system.
      '';
    };

    nesting.children = mkOption {
      default = [];
      description = ''
        Additional configurations to build.
      '';
    };

    nesting.clone = mkOption {
      default = [];
      description = ''
        Additional configurations to build based on the current
        configuration which then has a lower priority.

        To switch to a cloned configuration (e.g. <literal>child-1</literal>)
        at runtime, run

        <programlisting>
        # sudo /run/current-system/fine-tune/child-1/bin/switch-to-configuration test
        </programlisting>
      '';
    };

    system.boot.loader.id = mkOption {
      internal = true;
      default = "";
      description = ''
        Id string of the used bootloader.
      '';
    };

    system.boot.loader.kernelFile = mkOption {
      internal = true;
      default = pkgs.stdenv.hostPlatform.platform.kernelTarget;
      type = types.str;
      description = ''
        Name of the kernel file to be passed to the bootloader.
      '';
    };

    system.boot.loader.initrdFile = mkOption {
      internal = true;
      default = "initrd";
      type = types.str;
      description = ''
        Name of the initrd file to be passed to the bootloader.
      '';
    };

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
      example = lib.literalExample "[ ({ original = pkgs.openssl; replacement = pkgs.callPackage /path/to/openssl { }; }) ]";
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
