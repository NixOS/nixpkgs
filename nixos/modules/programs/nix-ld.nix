{ pkgs, lib, config, ... }:
let
  inherit (lib)
    literalExpression
    mapAttrsToList
    mergeAttrsList
    mkEnableOption
    mkMerge
    mkOption
    mkPackageOption
    types;

  cfg = config.programs.nix-ld.systems;

  share-path = system: "share/nix-ld-${system}";

  nix-ld-libraries = system: cfg: cfg.pkgs.buildEnv {
    name = "ld-library-path";
    pathsToLink = [ "/lib" ];
    paths = map lib.getLib cfg.libraries;
    # TODO make glibc here configurable?
    postBuild = ''
      ln -s ${cfg.pkgs.stdenv.cc.bintools.dynamicLinker} $out/${share-path system}/lib/ld.so
    '';
    extraPrefix = "/${share-path system}";
    ignoreCollisions = true;
  };
in
{
  meta.maintainers = [ lib.maintainers.mic92 ];

  options.programs.nix-ld.systems = mkOption {
    default = { };
    description = ''
      Configure nix-ld for the given system.
    '';
    type = types.attrsOf (types.submodule {
      options = {
        enable = mkEnableOption "nix-ld for the given system";
        package = mkPackageOption pkgs "nix-ld" { };

        pkgs = mkOption {
          type = types.pkgs;
          default = pkgs;
          defaultText = "pkgs";
          description = "Package set to use";
        };

        ldso = mkOption {
          type = types.str;
          description = ''
            Which runtime loader to override, either `ldso` or `ldso32`, see
            `environment.ldso` and `environment.ldso32`.
          '';
          default = "ldso";
        };

        libraries = mkOption {
          type = types.listOf types.package;
          description = "Libraries that automatically become available to all programs. The default set includes common libraries.";
          default = [ ];
          defaultText = literalExpression "baseLibraries derived from systemd and nix dependencies.";
        };
      };
    });
  };

  config =
    let
      recursive =
        # mkMerge
        mergeAttrsList
          (mapAttrsToList
            (system: cfg: {
              environment.${cfg.ldso} = "${cfg.package}/libexec/nix-ld";

              environment.systemPackages = [ (nix-ld-libraries system cfg) ];

              environment.pathsToLink = [ "/${share-path system}" ];

              environment.variables = {
                "NIX_LD_${builtins.replaceStrings ["-"] ["_"] system}" = "/run/current-system/sw/${share-path system}/lib/ld.so";
                "NIX_LD_LIBRARY_PATH_${builtins.replaceStrings ["-"] ["_"] system}" = "/run/current-system/sw/${share-path system}/lib";
              };

              # We currently take all libraries from systemd and nix as the default.
              # Is there a better list?
              programs.nix-ld.systems.${system}.libraries = with cfg.pkgs; [
                zlib
                zstd
                stdenv.cc.cc
                curl
                openssl
                attr
                libssh
                bzip2
                libxml2
                acl
                libsodium
                util-linux
                xz
                systemd
              ];
            })
            cfg);
    in
    # recursive;
    { environment.etc.foo.text = builtins.toJSON recursive; };
}
