let
  pkgs = import ../../.. {
    config = { };
    overlays = [ ];
  };

  common = import ./common.nix;
  inherit (common) outputPath indexPath;
  devmode = pkgs.devmode.override {
    buildArgs = ''${toString ../../release.nix} -A manualHTML.${builtins.currentSystem}'';
    open = "/${outputPath}/${indexPath}";
  };
<<<<<<< HEAD
  nixos-render-docs-redirects = pkgs.writeShellScriptBin "redirects" ''${pkgs.lib.getExe pkgs.nixos-render-docs-redirects} --file '${toString ./redirects.json}' "$@"'';
=======
  nixos-render-docs-redirects = pkgs.writeShellScriptBin "redirects" "${pkgs.lib.getExe pkgs.nixos-render-docs-redirects} --file ${toString ./redirects.json} $@";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
in
pkgs.mkShellNoCC {
  packages = [
    devmode
    nixos-render-docs-redirects
  ];
}
