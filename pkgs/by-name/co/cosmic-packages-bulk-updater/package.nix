{
  pkgs, # required to get a list of all actionable packages
  lib,
  stdenvNoCC,
  writeShellScript,
  git,
}:

let
  hasMetaAttr = pkg: pkg ? meta;
  hasMetaTeamsAttr = pkg: if hasMetaAttr pkg then pkg.meta ? teams else false;
  isMaintainedByCosmicTeam =
    pkg: if hasMetaTeamsAttr pkg then builtins.elem lib.teams.cosmic pkg.meta.teams else false;
  getPkgPname = pkg: if pkg ? pname then pkg.pname else null;
  ignoredMaintainedPkgs =
    pkg:
    !(builtins.elem (getPkgPname pkg) [
      "cosmic-design-demo"
      "cosmic-packages-bulk-updater"
      null
    ]);
  allPkgs = lib.attrsets.attrValues pkgs;
  cosmicPkgs = builtins.filter (
    pkg:
    let
      result = builtins.tryEval (isMaintainedByCosmicTeam pkg && ignoredMaintainedPkgs pkg);
    in
    result.success && result.value
  ) allPkgs;
  cosmicPackagesList = builtins.map (pkg: getPkgPname pkg) cosmicPkgs;
in

stdenvNoCC.mkDerivation {
  pname = "cosmic-packages-bulk-updater";
  version = "0.1.0";

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir $out
    echo '${lib.strings.concatStringsSep "\n" cosmicPackagesList}' > $out/pkgs-to-be-auto-upgraded
  '';

  passthru.updateScript = writeShellScript "update-cosmic-packages" ''
    set -xeuf -o pipefail

    pushd "$(${git}/bin/git rev-parse --show-toplevel)" || exit 1
    exec nix-shell maintainers/scripts/update.nix \
        --argstr commit true \
        --argstr keep-going true \
        --argstr max-workers 1 \
        --argstr skip-prompt true \
        --arg predicate '(path: pkg: builtins.elem (pkg.pname or "") ["${lib.strings.concatStringsSep "\" \" " cosmicPackagesList}"])'
  '';

  meta = {
    description = ''
      A package to auto-upgrade all COSMIC packages maintained by the nixpkgs COSMIC team.
      **PLEASE DO NOT INSTALL THIS**
    '';
    license = lib.licenses.mit;
    teams = [ lib.teams.cosmic ];
    platforms = lib.platforms.linux;
    hydraPlatforms = [ ]; # no need to build this in Hydra
  };
}
