{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.cabal-install;

  cabal-exec-deps = [
    pkgs.binutils-unwrapped
    pkgs.gnutar
  ];
  cabal-install-wrapper = pkgs.stdenv.mkDerivation {
      inherit (pkgs.cabal-install) pname version;
      nativeBuildInputs = [ pkgs.makeWrapper ];
      buildCommand = ''
        makeWrapper ${pkgs.cabal-install}/bin/cabal $out/bin/cabal \
          --prefix PATH : ${lib.makeBinPath cabal-exec-deps}
      '';
    };
in {

  meta.maintainers = [ maintainers.xaverdh ];

  options = {
    programs.cabal-install = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Put a cabal-install wrapper binary into PATH, with
          its runtime dependencies in place.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cabal-install-wrapper ];
  };

}

