{
  maintainer,
  localSystem ? {
    system = args.system or builtins.currentSystem;
  },
  system ? localSystem.system,
  crossSystem ? localSystem,
  ...
}@args:

# based on update.nix
# nix-build build.nix --argstr maintainer <yourname>

# to build for aarch64-linux using boot.binfmt.emulatedSystems:
# nix-build build.nix --argstr maintainer <yourname> --argstr system aarch64-linux

let
  lib = import ../../lib;

  # Git doesn't track directories, so switching branches can leave a `pkgs/by-name/xx/foo` directory
  # behind that is empty or holds only untracked files. The by-name overlay would then call its
  # nonexistent `package.nix` and fail evaluation of this whole script. Mask such entries here,
  # rather than in `pkgs/top-level/by-name-overlay.nix`, so that every other evaluation of Nixpkgs
  # doesn't pay for the check. See <https://github.com/NixOS/nixpkgs/issues/338227>.
  byNameDir = ../../pkgs/by-name;
  missingByNamePackages = lib.concatMapAttrs (
    shard: type:
    lib.optionalAttrs (type == "directory") (
      lib.concatMapAttrs (
        name: _:
        lib.optionalAttrs (!builtins.pathExists (byNameDir + "/${shard}/${name}/package.nix")) {
          ${name} = null;
        }
      ) (builtins.readDir (byNameDir + "/${shard}"))
    )
  ) (builtins.readDir byNameDir);

  nixpkgsArgs =
    removeAttrs args [
      "maintainer"
      "overlays"
    ]
    // {
      overlays = [ (_: _: missingByNamePackages) ] ++ args.overlays or [ ];
    };

  pkgs = import ./../../default.nix nixpkgsArgs;

  maintainer_ = pkgs.lib.maintainers.${maintainer};
  packagesWith =
    cond: return: set:
    (pkgs.lib.flatten (
      pkgs.lib.mapAttrsToList (
        name: pkg:
        let
          result = builtins.tryEval (
            if pkgs.lib.isDerivation pkg && cond name pkg then
              # Skip packages whose closure fails on evaluation.
              # This happens for pkgs like `python27Packages.djangoql`
              # that have disabled Python pkgs as dependencies.
              builtins.seq pkg.outPath [ (return name pkg) ]
            else if pkg.recurseForDerivations or false || pkg.recurseForRelease or false then
              packagesWith cond return pkg
            else
              [ ]
          );
        in
        if result.success then result.value else [ ]
      ) set
    ));
in
packagesWith (
  name: pkg:
  (
    if builtins.hasAttr "meta" pkg && builtins.hasAttr "maintainers" pkg.meta then
      (
        if builtins.isList pkg.meta.maintainers then
          builtins.elem maintainer_ pkg.meta.maintainers
        else
          maintainer_ == pkg.meta.maintainers
      )
    else
      false
  )
) (name: pkg: pkg) pkgs
