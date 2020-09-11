{ maintainer }:

# based on update.nix
# nix-build build.nix --argstr maintainer <yourname>

let
  pkgs = import ./../../default.nix {};
  maintainer_ = pkgs.lib.maintainers.${maintainer};
  packagesWith = cond: return: set:
    (pkgs.lib.flatten
      (pkgs.lib.mapAttrsToList
        (name: pkg:
          let
            result = builtins.tryEval
              (
                if pkgs.lib.isDerivation pkg && cond name pkg
                then [ (return name pkg) ]
                else if pkg.recurseForDerivations or false || pkg.recurseForRelease or false
                then packagesWith cond return pkg
                else [ ]
              );
          in
          if result.success then result.value
          else [ ]
        )
        set
      )
    );
in
packagesWith
  (name: pkg:
    (
      if builtins.hasAttr "meta" pkg && builtins.hasAttr "maintainers" pkg.meta
      then (
        if builtins.isList pkg.meta.maintainers
        then builtins.elem maintainer_ pkg.meta.maintainers
        else maintainer_ == pkg.meta.maintainers
      )
      else false
    )
  )
  (name: pkg: pkg)
  pkgs
