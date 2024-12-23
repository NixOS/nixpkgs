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
  # This avoids a common situation for maintainers, where due to Git's behavior of not tracking
  # directories, they have an empty directory somewhere in `pkgs/by-name`. Because that directory
  # exists, `pkgs/top-level/by-name-overlay.nix` picks it up and attempts to read `package.nix` out
  # of it... which doesn't exist, since it's empty.
  #
  # We don't want to run the code below on every instantiation of `nixpkgs`, as the `pkgs/by-name`
  # eval machinery is quite performance sensitive. So we use the internals of the `by-name` overlay
  # to implement our own way to avoid an evaluation failure for this script.
  #
  # See <https://github.com/NixOS/nixpkgs/issues/338227> for more motivation for this code block.
  overlay = self: super: {
    _internalCallByNamePackageFile =
      file: if builtins.pathExists file then super._internalCallByNamePackageFile file else null;
  };

  nixpkgsArgs =
    removeAttrs args [
      "maintainer"
      "overlays"
    ]
    // {
      overlays = args.overlays or [ ] ++ [ overlay ];
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
