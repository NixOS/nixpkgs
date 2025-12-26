{
  maintainer, # --argstr
  short ? false, # use --arg short true
  extra ? "", # --argstr
}:
let
  pkgs = import ./../../default.nix {
    config.allowAliases = false;
  };
  inherit (pkgs) lib;
  maintainer_ = pkgs.lib.maintainers.${maintainer};
  packagesWith =
    cond: return: prefix: set:
    (lib.flatten (
      lib.mapAttrsToList (
        name: pkg:
        let
          result = builtins.tryEval (
            if lib.isDerivation pkg && cond name pkg then
              # Skip packages whose closure fails on evaluation.
              # This happens for pkgs like `python27Packages.djangoql`
              # that have disabled Python pkgs as dependencies.
              builtins.seq pkg.outPath [ (return "${prefix}${name}") ]
            else if
              pkg.recurseForDerivations or false || pkg.recurseForRelease or false
            # then packagesWith cond return pkg
            then
              packagesWith cond return "${name}." pkg
            else
              [ ]
          );
        in
        if result.success then result.value else [ ]
      ) set
    ));

  packages = builtins.trace "evaluating list of packages for maintainer: ${maintainer}" packagesWith (
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
  ) (name: name) "" pkgs;

in
pkgs.stdenvNoCC.mkDerivation {
  name = "check-hydra-by-maintainer";
  buildInputs = [ pkgs.hydra-check ];
  buildCommand = ''
    echo ""
    echo "----------------------------------------------------------------"
    echo ""
    echo "nix-shell maintainers/scripts/check-hydra-by-maintainer.nix --argstr maintainer yourname"
    echo ""
    echo "nix-shell maintainers/scripts/check-hydra-by-maintainer.nix --argstr maintainer yourname --arg short true"
    echo ""
    echo "nix-shell maintainers/scripts/check-hydra-by-maintainer.nix --argstr maintainer yourname --argstr extra \"--json\""
    echo ""
    echo "----------------------------------------------------------------"
    exit 1
  '';
  shellHook =
    let
      # trying to only add spaces as necessary for optional args
      # with optStr don't need spaces between nix templating
      optStr = cond: string: lib.optionalString cond "${string} ";
      args = [
        "hydra-check"
      ]
      ++ (lib.optional short "--short")
      ++ (lib.optional (extra != "") extra)
      ++ (map lib.escapeShellArg packages);
      command = lib.concatStringsSep " " args;
    in
    ''
      # if user presses ctrl-c during run
      # pass on ctrl-c to fully quit rather than exiting to nix-shell
      function ctrl_c() {
        exit 130
      }
      trap ctrl_c INT
      echo "Please stand by"
      echo "${command}"
      ${command}
      exit $?
    '';
}
