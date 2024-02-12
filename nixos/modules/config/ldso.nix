{ config, lib, pkgs, ... }:

let
  inherit (lib) last splitString mkOption types mdDoc optionals;

  libDir = pkgs.stdenv.hostPlatform.libDir;
  ldsoBasename = builtins.unsafeDiscardStringContext (last (splitString "/" pkgs.stdenv.cc.bintools.dynamicLinker));
in {
  imports = [
    (lib.mkRemovedOptionModule ["environment" "ldso32"] "removed as it didn't work on all architectures")
  ];

  options = {
    environment.ldso = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = mdDoc ''
        The executable to link into the normal FHS location of the ELF loader.
      '';
    };
  };

  config = {
    systemd.tmpfiles.rules = (
      if isNull config.environment.ldso then [
        "r /${libDir}/${ldsoBasename} - - - - -"
      ] else [
        "d /${libDir} 0755 root root - -"
        "L+ /${libDir}/${ldsoBasename} - - - - ${config.environment.ldso}"
      ]
    );
  };

  meta.maintainers = with lib.maintainers; [ tejing ];
}
