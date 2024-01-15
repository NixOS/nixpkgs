{ config, lib, pkgs, ... }:

let
  inherit (lib) last splitString mkOption types mdDoc optionals;

  libDir = pkgs.stdenv.hostPlatform.libDir;
  ldsoBasename = builtins.unsafeDiscardStringContext (last (splitString "/" pkgs.stdenv.cc.bintools.dynamicLinker));

  pkgs32 = pkgs.pkgsi686Linux;
  libDir32 = pkgs32.stdenv.hostPlatform.libDir;
  ldsoBasename32 = builtins.unsafeDiscardStringContext (last (splitString "/" pkgs32.stdenv.cc.bintools.dynamicLinker));
in {
  options = {
    environment.ldso = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = mdDoc ''
        The executable to link into the normal FHS location of the ELF loader.
      '';
    };

    environment.ldso32 = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = mdDoc ''
        The executable to link into the normal FHS location of the 32-bit ELF loader.

        This currently only works on x86_64 architectures.
      '';
    };
  };

  config = {
    assertions = [
      { assertion = isNull config.environment.ldso32 || pkgs.stdenv.isx86_64;
        message = "Option environment.ldso32 currently only works on x86_64.";
      }
    ];

    systemd.tmpfiles.rules = (
      if isNull config.environment.ldso then [
        "r /${libDir}/${ldsoBasename} - - - - -"
      ] else [
        "d /${libDir} 0755 root root - -"
        "L+ /${libDir}/${ldsoBasename} - - - - ${config.environment.ldso}"
      ]
    ) ++ optionals pkgs.stdenv.isx86_64 (
      if isNull config.environment.ldso32 then [
        "r /${libDir32}/${ldsoBasename32} - - - - -"
      ] else [
        "d /${libDir32} 0755 root root - -"
        "L+ /${libDir32}/${ldsoBasename32} - - - - ${config.environment.ldso32}"
      ]
    );
  };

  meta.maintainers = with lib.maintainers; [ tejing ];
}
