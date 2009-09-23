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
    
  };

    
  # This attribute is responsible for creating boot entries for 
  # child configuration. They are only (directly) accessible
  # when the parent configuration is boot default. For example,
  # you can provide an easy way to boot the same configuration 
  # as you use, but with another kernel
  # !!! fix this
  children = map (x: ((import ../../../default.nix)
    { configuration = x//{boot=((x.boot)//{grubDevice = "";});};}).system) 
    config.nesting.children;


  systemBuilder =
    ''
      ensureDir $out

      ln -s ${config.boot.kernelPackages.kernel}/uImage $out/kernel
      if [ -n "$grub" ]; then 
        ln -s $grub $out/grub
      fi
      ln -s ${config.system.build.bootStage2} $out/init
      ln -s ${config.system.build.initialRamdisk}/initrd $out/initrd
      ln -s ${config.system.activationScripts.script} $out/activate
      ln -s ${config.system.build.etc}/etc $out/etc
      ln -s ${config.system.path} $out/sw
      ln -s ${pkgs.upstart} $out/upstart

      echo "$kernelParams" > $out/kernel-params
      echo "$configurationName" > $out/configuration-name
      echo "${toString pkgs.upstart.interfaceVersion}" > $out/upstart-interface-version

      mkdir $out/fine-tune
      childCount=0;
      for i in $children; do 
        childCount=$(( childCount + 1 ));
        ln -s $i $out/fine-tune/child-$childCount;
      done

      ensureDir $out/bin
      substituteAll ${./switch-to-configuration.sh} $out/bin/switch-to-configuration
      chmod +x $out/bin/switch-to-configuration
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
    grub = if (pkgs.stdenv.system != "armv5tel-linux") then pkgs.grub
      else null;
    grubDevice = config.boot.grubDevice;
    kernelParams =
      config.boot.kernelParams ++ config.boot.extraKernelParams;
    grubMenuBuilder = config.system.build.grubMenuBuilder;
    configurationName = config.boot.configurationName;
    # Most of these are needed by grub-install.
    path = [
      pkgs.coreutils
      pkgs.gnused
      pkgs.gnugrep
      pkgs.findutils
      pkgs.diffutils
      pkgs.upstart # for initctl
    ];
  };


in {
  require = [options];

  system.build.toplevel = system;
}
