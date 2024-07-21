let
  pkgs = import ../../../../../. {
    config.allowBroken = true;
  };
  inherit (pkgs) lib emacs;
  inherit (lib) isDerivation hasAttr filterAttrs mapAttrs attrValues;

  # Extract updateScript's from manually package emacs packages
  hasScript = filterAttrs (_: v: isDerivation v && hasAttr "updateScript" v) emacs.pkgs.manualPackages;

in attrValues (mapAttrs (_: v: v.updateScript) hasScript)
