{ config, lib, pkgs, ... }:

let
  inherit (lib) last splitString mkOption types optionals;

  libDir = pkgs.stdenv.hostPlatform.libDir;
  ldsoBasename = builtins.unsafeDiscardStringContext (last (splitString "/" pkgs.stdenv.cc.bintools.dynamicLinker));

  # Hard-code to avoid creating another instance of nixpkgs. Also avoids eval errors in some cases.
  libDir32 = "lib"; # pkgs.pkgsi686Linux.stdenv.hostPlatform.libDir
  ldsoBasename32 = "ld-linux.so.2"; # last (splitString "/" pkgs.pkgsi686Linux.stdenv.cc.bintools.dynamicLinker)
in {
  options = {
    environment.ldso = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        The executable to link into the normal FHS location of the ELF loader.
      '';
    };

    environment.ldso32 = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        The executable to link into the normal FHS location of the 32-bit ELF loader.

        This currently only works on x86_64 architectures.
      '';
    };
  };

  config = {
    assertions = [
      { assertion = isNull config.environment.ldso32 || pkgs.stdenv.hostPlatform.isx86_64;
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
    ) ++ optionals pkgs.stdenv.hostPlatform.isx86_64 (
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
