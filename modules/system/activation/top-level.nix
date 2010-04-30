{pkgs, config, ...}:

let

  options = {
  
    system.build = pkgs.lib.mkOption {
      default = {};
      description = ''
        Attribute set of derivations used to setup the system.
      '';
    };

    nesting.children = pkgs.lib.mkOption {
      default = [];
      description = ''
        Additional configurations to build.
      '';
    };

    system.boot.loader.id = pkgs.lib.mkOption {
      default = "";
      description = ''
        Id string of the used bootloader.
      '';
    };

    system.boot.loader.kernelFile = pkgs.lib.mkOption {
      default = "";
      description = ''
        Name of the kernel file to be passed to the bootloader.
      '';
    };

    system.copySystemConfiguration = pkgs.lib.mkOption {
      default = false;
      description = ''
        Unless set to false copies the nixos configuration file
        <literal>$NIXOS_CONFIG</literal> defaulting to
        <filename>/etc/nixos/configuration.nix</filename>
        to the system store path.
        See <option>extraSystemBuilderCmds</option>
        if you want to do add more customized info
        to your system storepath.
      '';
    };

    system.extraSystemBuilderCmds = pkgs.lib.mkOption {
      default = "";
      merge = pkgs.lib.concatStringsSep "\n";
      description = ''
        This code will be added to the builder creating the system store path.
        This use case copies your configuration file into the system derivation:
        <command>
        cp ${pkgs.lib.maybeEnv "NIXOS_CONFIG" "/etc/nixos/configuration.nix"} $out
        </command>
        Of course you could add code saving a svn diff or svn revision number
        of both nixos and nixpkgs repositories as well. Keep in mind that when
        you build in chroots that you have do either copy sources to store or
        add them to the chroot somehow.
        You still should consider putting your configuration into a VCS.
      '';
    };
    
  };

    
  # This attribute is responsible for creating boot entries for 
  # child configuration. They are only (directly) accessible
  # when the parent configuration is boot default. For example,
  # you can provide an easy way to boot the same configuration 
  # as you use, but with another kernel
  # !!! fix this
  children = with pkgs.lib;
    map (childConfig:
      (import ../../../lib/eval-config.nix {
        modules = [
          (recursiveUpdate childConfig {
            boot.loader.grub.device = "";
            # undefined the obsolete name of the previous option.
            boot.grubDevice = pkgs.lib.mkNotdef;
          })
        ] ++ attrByPath ["require"] [] childConfig;
      }).config.system.build.toplevel
    ) config.nesting.children;


  systemBuilder =
    let
      kernelPath = "${config.boot.kernelPackages.kernel}/" +
        "${config.system.boot.loader.kernelFile}";
    in 
      ''
      ensureDir $out

      if [ ! -f ${kernelPath} ]; then
        echo "The bootloader cannot find the proper kernel image."
        echo "(Expecting ${kernelPath})"
        false
      fi
      ln -s ${kernelPath} $out/kernel
      ln -s ${config.system.modulesTree} $out/kernel-modules
      if [ -n "$grub" ]; then 
        ln -s $grub $out/grub
      fi
      ln -s ${config.system.build.bootStage2} $out/init
      ln -s ${config.system.build.initialRamdisk}/initrd $out/initrd
      ln -s ${config.system.activationScripts.script} $out/activate
      ln -s ${config.system.build.etc}/etc $out/etc
      ln -s ${config.system.path} $out/sw
      ln -s ${config.system.build.upstart} $out/upstart
      ln -s ${config.hardware.firmware} $out/firmware

      echo "$kernelParams" > $out/kernel-params
      echo "$configurationName" > $out/configuration-name
      echo "${toString config.system.build.upstart.interfaceVersion}" > $out/upstart-interface-version

      mkdir $out/fine-tune
      childCount=0;
      for i in $children; do 
        childCount=$(( childCount + 1 ));
        ln -s $i $out/fine-tune/child-$childCount;
      done

      ensureDir $out/bin
      substituteAll ${./switch-to-configuration.sh} $out/bin/switch-to-configuration
      chmod +x $out/bin/switch-to-configuration

      ${config.system.extraSystemBuilderCmds}
    '';

  
  # Putting it all together.  This builds a store path containing
  # symlinks to the various parts of the built configuration (the
  # kernel, the Upstart services, the init scripts, etc.) as well as a
  # script `switch-to-configuration' that activates the configuration
  # and makes it bootable.
  system = pkgs.stdenv.mkDerivation {
    name = "system";
    buildCommand = systemBuilder;
    inherit children;
    kernelParams =
      config.boot.kernelParams ++ config.boot.extraKernelParams;
    menuBuilder = config.system.build.menuBuilder;
    initScriptBuilder = config.system.build.initScriptBuilder;
    # Most of these are needed by grub-install.
    path = [
      pkgs.coreutils
      pkgs.gnused
      pkgs.gnugrep
      pkgs.findutils
      pkgs.diffutils
      config.system.build.upstart # for initctl
    ];

    # Boot loaders
    bootLoader = config.system.boot.loader.id;
    grub =
      if config.boot.loader.grub.enable
      then config.system.build.grub
      else null;
    grubVersion = 
      if config.boot.loader.grub.enable
      then (builtins.parseDrvName config.system.build.grub.name).version
      else "";
    grubDevice = config.boot.loader.grub.device;
    configurationName = config.boot.loader.grub.configurationName;
  };


in {
  require = [options];

  system.extraSystemBuilderCmds =
      pkgs.lib.optionalString
          config.system.copySystemConfiguration
          "cp ${pkgs.lib.maybeEnv "NIXOS_CONFIG" "/etc/nixos/configuration.nix"} $out";
  system.build.toplevel = system;
}
