{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.iproute2;

  etc_iproute2 = pkgs.stdenv.mkDerivation {
    name = "etc-iproute2";
    src = pkgs.iproute2;
    buildPhase = ''
      mkdir $out
      ln -s $src/etc/iproute2/* $out/
      rm -f $out/rt_tables
      cat $src/etc/iproute2/rt_tables ${builtins.toFile "rt-tables_extra-config" cfg.rttablesExtraConfig} > $out/rt_tables
    '';
  };
in
{
  options.networking.iproute2 = {
    enable = mkEnableOption (lib.mdDoc "copy IP route configuration files");
    rttablesExtraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Verbatim lines to add to /etc/iproute2/rt_tables
      '';
    };
  };

  config.environment.etc = optionalAttrs cfg.enable { iproute2.source = etc_iproute2; };
}
