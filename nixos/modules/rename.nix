{pkgs, options, config, ...}:

let

  alias = from: to: {
    name = "Alias";
    msg.use = x: x;
    msg.define = x: x;
  };

  obsolete = from: to: {
    name = "Obsolete name";
    msg.use = x:
      builtins.trace "Obsolete option `${from}' is used instead of `${to}'." x;
    msg.define = x:
      builtins.trace "Obsolete option `${from}' is defined instead of `${to}'." x;
  };

  deprecated = from: to: {
    name = "Deprecated name";
    msg.use = x:
      abort "Deprecated option `${from}' is used instead of `${to}'.";
    msg.define = x:
      abort "Deprecated option `${from}' is defined instead of `${to}'.";
  };


  zipModules = list: with pkgs.lib;
    zipAttrsWith (n: v:
      if tail v != [] then
        if n == "_type" then (head v)
        else if n == "extraConfigs" then (concatLists v)
        else if n == "description" || n == "apply" then
          abort "Cannot rename an option to multiple options."
        else zipModules v
      else head v
    ) list;

  rename = statusTemplate: from: to: with pkgs.lib;
    let
      status = statusTemplate from to;
      setTo = setAttrByPath (splitString "." to);
      setFrom = setAttrByPath (splitString "." from);
      toOf = attrByPath (splitString "." to)
        (abort "Renaming error: option `${to}' does not exists.");
      fromOf = attrByPath (splitString "." from)
        (abort "Internal error: option `${from}' should be declared.");
    in
      [{
        options = setFrom (mkOption {
          description = "${status.name} of <option>${to}</option>.";
          apply = x: status.msg.use (toOf config);
        });
      }] ++
      [{
        options = setTo (mkOption {
          extraConfigs =
            let externalDefs = (fromOf options).definitions; in
            if externalDefs == [] then []
            else map (def: def.value) (status.msg.define externalDefs);
        });
      }];

in zipModules ([]

# usage example:
# ++ rename alias "services.xserver.slim.theme" "services.xserver.displayManager.slim.theme"
++ rename obsolete "environment.extraPackages" "environment.systemPackages"
++ rename obsolete "environment.enableBashCompletion" "programs.bash.enableCompletion"

++ rename obsolete "security.extraSetuidPrograms" "security.setuidPrograms"
++ rename obsolete "networking.enableWLAN" "networking.wireless.enable"
++ rename obsolete "networking.enableRT73Firmware" "networking.enableRalinkFirmware"

# FIXME: Remove these eventually.
++ rename obsolete "boot.systemd.sockets" "systemd.sockets"
++ rename obsolete "boot.systemd.targets" "systemd.targets"
++ rename obsolete "boot.systemd.services" "systemd.services"

# Old Grub-related options.
++ rename obsolete "boot.copyKernels" "boot.loader.grub.copyKernels"
++ rename obsolete "boot.extraGrubEntries" "boot.loader.grub.extraEntries"
++ rename obsolete "boot.extraGrubEntriesBeforeNixos" "boot.loader.grub.extraEntriesBeforeNixOS"
++ rename obsolete "boot.grubDevice" "boot.loader.grub.device"
++ rename obsolete "boot.bootMount" "boot.loader.grub.bootDevice"
++ rename obsolete "boot.grubSplashImage" "boot.loader.grub.splashImage"

++ rename obsolete "boot.initrd.extraKernelModules" "boot.initrd.kernelModules"

# OpenSSH
++ rename obsolete "services.sshd.ports" "services.openssh.ports"
++ rename alias "services.sshd.enable" "services.openssh.enable"
++ rename obsolete "services.sshd.allowSFTP" "services.openssh.allowSFTP"
++ rename obsolete "services.sshd.forwardX11" "services.openssh.forwardX11"
++ rename obsolete "services.sshd.gatewayPorts" "services.openssh.gatewayPorts"
++ rename obsolete "services.sshd.permitRootLogin" "services.openssh.permitRootLogin"
++ rename obsolete "services.xserver.startSSHAgent" "services.xserver.startOpenSSHAgent"

# KDE
++ rename deprecated "kde.extraPackages" "environment.kdePackages"
# ++ rename obsolete "environment.kdePackages" "environment.systemPackages" # !!! doesn't work!

# Multiple efi bootloaders now
++ rename obsolete "boot.loader.efi.efibootmgr.enable" "boot.loader.efi.canTouchEfiVariables"

# NixOS environment changes
# !!! this hardcodes bash, could we detect from config which shell is actually used?
++ rename obsolete "environment.promptInit" "programs.bash.promptInit"

) # do not add renaming after this.
