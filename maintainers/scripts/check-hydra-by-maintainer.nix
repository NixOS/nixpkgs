{ maintainer }:
let
  pkgs = import ./../../default.nix {
    config.allowAliases = false;
  };
  inherit (pkgs) lib;
  maintainer_ = pkgs.lib.maintainers.${maintainer};
  packagesWith = cond: return: prefix: set:
    (lib.flatten
      (lib.mapAttrsToList
        (name: pkg:
          let
            result = builtins.tryEval
              (
                if lib.isDerivation pkg && cond name pkg then
                # Skip packages whose closure fails on evaluation.
                # This happens for pkgs like `python27Packages.djangoql`
                # that have disabled Python pkgs as dependencies.
                  builtins.seq pkg.outPath
                    [ (return "${prefix}${name}") ]
                else if pkg.recurseForDerivations or false || pkg.recurseForRelease or false
                # then packagesWith cond return pkg
                then packagesWith cond return "${name}." pkg
                else [ ]
              );
          in
          if result.success then result.value
          else [ ]
        )
        set
      )
    );

  packages = packagesWith
    (name: pkg:
      (
        if builtins.hasAttr "meta" pkg && builtins.hasAttr "maintainers" pkg.meta
        then
          (
            if builtins.isList pkg.meta.maintainers
            then builtins.elem maintainer_ pkg.meta.maintainers
            else maintainer_ == pkg.meta.maintainers
          )
        else false
      )
    )
    (name: name)
    ""
    pkgs;

in
pkgs.stdenv.mkDerivation {
  name = "nixpkgs-update-script";
  buildInputs = [ pkgs.hydra-check ];
  buildCommand = ''
    echo ""
    echo "----------------------------------------------------------------"
    echo ""
    echo "nix-shell maintainers/scripts/check-hydra-by-maintainer.nix --argstr maintainer SuperSandro2000"
    echo ""
    echo "----------------------------------------------------------------"
    exit 1
  '';
  shellHook = ''
    unset shellHook # do not contaminate nested shells
    echo "Please stand by"
    echo nix-shell -p hydra-check --run "hydra-check ${builtins.concatStringsSep " " packages}"
    nix-shell -p hydra-check --run "hydra-check ${builtins.concatStringsSep " " packages}"
    exit $?
  '';
}
