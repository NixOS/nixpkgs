{pkgs, options, config, ...}:


let
  to = throw "This is just a dummy keyword";
  alias = { name = "Alias"; };
  obsolete = { name = "Obsolete name"; };

  zipModules = list: with pkgs.lib;
    zip (n: v:
      if tail v != [] then zipModules v else head v
    ) list;

  rename = fromStatus: from: keyword: to: with pkgs.lib;
    let
      setTo = setAttrByPath (splitString "." to);
      setFrom = setAttrByPath (splitString "." from);
      toOf = attrByPath (splitString "." to) (abort "bad renaming");
      fromOf = attrByPath (splitString "." from) (abort "IE: renaming error");
    in
      [{
        options = setFrom (mkOption {
          description = "${fromStatus.name} of <option>${to}</option>.";
          apply = x: toOf config;
        });
      }] ++
      [{
        options = setTo (mkOption {
          extraConfigs = map (def: def.value) (fromOf options).definitions;
        });
      }];

in zipModules ([]

# usage example:
# ++ rename alias "services.xserver.slim.theme" to "services.xserver.displayManager.slim.theme"
++ rename obsolete "environment.extraPackages" to "environment.systemPackages"

# Old Grub-related options.
++ rename obsolete "boot.copyKernels" to "boot.loader.grub.copyKernels"
++ rename obsolete "boot.extraGrubEntries" to "boot.loader.grub.extraEntries"
++ rename obsolete "boot.extraGrubEntriesBeforeNixos" to "boot.loader.grub.extraEntriesBeforeNixOS"
++ rename obsolete "boot.grubDevice" to "boot.loader.grub.device"
++ rename obsolete "boot.bootMount" to "boot.loader.grub.bootDevice"


) # do not add renaming after this.
