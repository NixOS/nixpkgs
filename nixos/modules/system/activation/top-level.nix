{ config, pkgs, modules, baseModules, ... }:

with pkgs.lib;

let


  # This attribute is responsible for creating boot entries for
  # child configuration. They are only (directly) accessible
  # when the parent configuration is boot default. For example,
  # you can provide an easy way to boot the same configuration
  # as you use, but with another kernel
  # !!! fix this
  cloner = inheritParent: list: with pkgs.lib;
    map (childConfig:
      (import ../../../lib/eval-config.nix {
        inherit baseModules;
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
    in ''
      mkdir $out

      if [ ! -f ${kernelPath} ]; then
        echo "The bootloader cannot find the proper kernel image."
        echo "(Expecting ${kernelPath})"
        false
      fi

      ln -s ${kernelPath} $out/kernel
      ln -s ${config.system.modulesTree} $out/kernel-modules

      ln -s ${config.system.build.initialRamdisk}/initrd $out/initrd

      echo "$activationScript" > $out/activate
      substituteInPlace $out/activate --subst-var out
      chmod u+x $out/activate
      unset activationScript

      cp ${config.system.build.bootStage2} $out/init
      substituteInPlace $out/init --subst-var-by systemConfig $out

      ln -s ${config.system.build.etc}/etc $out/etc
      ln -s ${config.system.path} $out/sw
      ln -s "$systemd" $out/systemd
      ln -s ${config.hardware.firmware} $out/firmware

      echo -n "$kernelParams" > $out/kernel-params
      echo -n "$configurationName" > $out/configuration-name
      echo -n "systemd ${toString config.systemd.package.interfaceVersion}" > $out/init-interface-version
      echo -n "$nixosVersion" > $out/nixos-version

      mkdir $out/fine-tune
      childCount=0
      for i in $children; do
        childCount=$(( childCount + 1 ))
        ln -s $i $out/fine-tune/child-$childCount
      done

      mkdir $out/bin
      substituteAll ${./switch-to-configuration.pl} $out/bin/switch-to-configuration
      chmod +x $out/bin/switch-to-configuration

      ${config.system.extraSystemBuilderCmds}
    '';


  # Putting it all together.  This builds a store path containing
  # symlinks to the various parts of the built configuration (the
  # kernel, the Upstart services, the init scripts, etc.) as well as a
  # script `switch-to-configuration' that activates the configuration
  # and makes it bootable.
  system = pkgs.stdenv.mkDerivation {
    name = "nixos-${config.system.nixosVersion}";
    preferLocalBuild = true;
    buildCommand = systemBuilder;

    inherit (pkgs) utillinux coreutils;
    systemd = config.systemd.package;

    inherit children;
    kernelParams =
      config.boot.kernelParams ++ config.boot.extraKernelParams;
    installBootLoader =
      config.system.build.installBootLoader
      or "echo 'Warning: do not know how to make this configuration bootable; please enable a boot loader.' 1>&2; true";
    activationScript = config.system.activationScripts.script;
    nixosVersion = config.system.nixosVersion;

    jobs = map (j: j.name) (attrValues config.jobs);

    # Pass the names of all Upstart tasks to the activation script.
    tasks = attrValues (mapAttrs (n: v: if v.task then ["[${v.name}]=1"] else []) config.jobs);

    # Pass the names of all Upstart jobs that shouldn't be restarted
    # to the activation script.
    noRestartIfChanged = attrValues (mapAttrs (n: v: if v.restartIfChanged then [] else ["[${v.name}]=1"]) config.jobs);

    configurationName = config.boot.loader.grub.configurationName;

    # Needed by switch-to-configuration.
    perl = "${pkgs.perl}/bin/perl -I${pkgs.perlPackages.FileSlurp}/lib/perl5/site_perl";
  };


in

{
  options = {

    system.build = mkOption {
      internal = true;
      default = {};
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
        configuration which is has a lower priority.
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
      default = pkgs.stdenv.platform.kernelTarget;
      type = types.uniq types.string;
      description = ''
        Name of the kernel file to be passed to the bootloader.
      '';
    };

    system.copySystemConfiguration = mkOption {
      default = false;
      description = ''
        If enabled, copies the NixOS configuration file
        <literal>$NIXOS_CONFIG</literal> (usually
        <filename>/etc/nixos/configuration.nix</filename>)
        to the system store path.
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

  };


  config = {

    system.extraSystemBuilderCmds =
      optionalString
        config.system.copySystemConfiguration
        "cp ${maybeEnv "NIXOS_CONFIG" "/etc/nixos/configuration.nix"} $out";

    system.build.toplevel = system;

  };

}
