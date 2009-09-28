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
# ++ rename obsolete "environment.extraPackages" to "environment.systemPackages"



) # do not add renaming after this.
