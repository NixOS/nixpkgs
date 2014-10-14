{ config, lib, options, ... }:

with lib;

let

  alias = from: to: rename {
    inherit from to;
    name = "Alias";
    use = id;
    define = id;
    visible = true;
  };

  # warn option was renamed
  obsolete = from: to: rename {
    inherit from to;
    name = "Obsolete name";
    use = x: builtins.trace "Obsolete option `${showOption from}' is used. It was renamed to `${showOption to}'." x;
    define = x: builtins.trace "Obsolete option `${showOption from}' is used. It was renamed to `${showOption to}'." x;
  };

  # abort if deprecated option is used
  deprecated = from: to: rename {
    inherit from to;
    name = "Deprecated name";
    use = x: abort "Deprecated option `${showOption from}' is used. It was renamed to `${showOption to}'.";
    define = x: abort "Deprecated option `${showOption from}' is used. It was renamed to `${showOption to}'.";
  };

  showOption = concatStringsSep ".";

  zipModules = list:
    zipAttrsWith (n: v:
      if tail v != [] then
        if n == "_type" then (head v)
        else if n == "warnings" then concatLists v
        else if n == "description" || n == "apply" then
          abort "Cannot rename an option to multiple options."
        else zipModules v
      else head v
    ) list;

  rename = { from, to, name, use, define, visible ? false }:
    let
      setTo = setAttrByPath to;
      setFrom = setAttrByPath from;
      toOf = attrByPath to
        (abort "Renaming error: option `${showOption to}' does not exists.");
      fromOf = attrByPath from
        (abort "Internal error: option `${showOption from}' should be declared.");
    in
      [ { options = setFrom (mkOption {
            description = "${name} of <option>${showOption to}</option>.";
            apply = x: use (toOf config);
            inherit visible;
          });
        }
        { config = setTo (mkMerge (if (fromOf options).isDefined then [ (define (mkMerge (fromOf options).definitions)) ] else []));
        }
      ];

  obsolete' = option: singleton
    { options = setAttrByPath option (mkOption {
        default = null;
        visible = false;
      });
      config.warnings = optional (getAttrFromPath option config != null)
        "The option `${showOption option}' defined in your configuration no longer has any effect; please remove it.";
    };

in zipModules ([]

++ obsolete [ "environment" "x11Packages" ] [ "environment" "systemPackages" ]
++ obsolete [ "environment" "enableBashCompletion" ] [ "programs" "bash" "enableCompletion" ]
++ obsolete [ "environment" "nix" ] [ "nix" "package" ]
++ obsolete [ "fonts" "extraFonts" ] [ "fonts" "fonts" ]

++ obsolete [ "security" "extraSetuidPrograms" ] [ "security" "setuidPrograms" ]
++ obsolete [ "networking" "enableWLAN" ] [ "networking" "wireless" "enable" ]
++ obsolete [ "networking" "enableRT73Firmware" ] [ "networking" "enableRalinkFirmware" ]

# FIXME: Remove these eventually.
++ obsolete [ "boot" "systemd" "sockets" ] [ "systemd" "sockets" ]
++ obsolete [ "boot" "systemd" "targets" ] [ "systemd" "targets" ]
++ obsolete [ "boot" "systemd" "services" ] [ "systemd" "services" ]

# Old Grub-related options.
++ obsolete [ "boot" "copyKernels" ] [ "boot" "loader" "grub" "copyKernels" ]
++ obsolete [ "boot" "extraGrubEntries" ] [ "boot" "loader" "grub" "extraEntries" ]
++ obsolete [ "boot" "extraGrubEntriesBeforeNixos" ] [ "boot" "loader" "grub" "extraEntriesBeforeNixOS" ]
++ obsolete [ "boot" "grubDevice" ] [ "boot" "loader" "grub" "device" ]
++ obsolete [ "boot" "bootMount" ] [ "boot" "loader" "grub" "bootDevice" ]
++ obsolete [ "boot" "grubSplashImage" ] [ "boot" "loader" "grub" "splashImage" ]

++ obsolete [ "boot" "initrd" "extraKernelModules" ] [ "boot" "initrd" "kernelModules" ]
++ obsolete [ "boot" "extraKernelParams" ] [ "boot" "kernelParams" ]

# OpenSSH
++ obsolete [ "services" "sshd" "ports" ] [ "services" "openssh" "ports" ]
++ alias [ "services" "sshd" "enable" ] [ "services" "openssh" "enable" ]
++ obsolete [ "services" "sshd" "allowSFTP" ] [ "services" "openssh" "allowSFTP" ]
++ obsolete [ "services" "sshd" "forwardX11" ] [ "services" "openssh" "forwardX11" ]
++ obsolete [ "services" "sshd" "gatewayPorts" ] [ "services" "openssh" "gatewayPorts" ]
++ obsolete [ "services" "sshd" "permitRootLogin" ] [ "services" "openssh" "permitRootLogin" ]
++ obsolete [ "services" "xserver" "startSSHAgent" ] [ "services" "xserver" "startOpenSSHAgent" ]
++ obsolete [ "services" "xserver" "startOpenSSHAgent" ] [ "programs" "ssh" "startAgent" ]
++ obsolete [ "services" "xserver" "windowManager" "xbmc" ] [ "services" "xserver" "desktopManager" "xbmc" ]

# KDE
++ deprecated [ "kde" "extraPackages" ] [ "environment" "kdePackages" ]
# ++ obsolete [ "environment" "kdePackages" ] [ "environment" "systemPackages" ] # !!! doesn't work!

# Multiple efi bootloaders now
++ obsolete [ "boot" "loader" "efi" "efibootmgr" "enable" ] [ "boot" "loader" "efi" "canTouchEfiVariables" ]

# NixOS environment changes
# !!! this hardcodes bash, could we detect from config which shell is actually used?
++ obsolete [ "environment" "promptInit" ] [ "programs" "bash" "promptInit" ]

++ obsolete [ "services" "xserver" "driSupport" ] [ "hardware" "opengl" "driSupport" ]
++ obsolete [ "services" "xserver" "driSupport32Bit" ] [ "hardware" "opengl" "driSupport32Bit" ]
++ obsolete [ "services" "xserver" "s3tcSupport" ] [ "hardware" "opengl" "s3tcSupport" ]
++ obsolete [ "hardware" "opengl" "videoDrivers" ] [ "services" "xserver" "videoDrivers" ]

++ obsolete [ "services" "mysql55" ] [ "services" "mysql" ]

# Options that are obsolete and have no replacement.
++ obsolete' [ "boot" "loader" "grub" "bootDevice" ]
++ obsolete' [ "boot" "initrd" "luks" "enable" ]
++ obsolete' [ "programs" "bash" "enable" ]
++ obsolete' [ "services" "samba" "defaultShare" ]

)
