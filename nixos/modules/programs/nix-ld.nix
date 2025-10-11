{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    literalExpression
    mergeAttrsList
    mkEnableOption
    mkOption
    mkPackageOption
    mkAliasOptionModule
    types
    ;

  cfg = config.programs.nix-ld.systems;

  share-path = system: "share/nix-ld-${system}";

  nix-ld-libraries =
    system: cfg:
    cfg.pkgs.buildEnv {
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

  imports =
    let
      # For generating the documentation, we don't have access to the system,
      # and it also reads better
      system = pkgs.system or ''''${pkgs.system}'';
    in
    [
      (mkAliasOptionModule
        [ "programs" "nix-ld" "enable" ]
        [ "programs" "nix-ld" "systems" system "enable" ]
      )
      (mkAliasOptionModule
        [ "programs" "nix-ld" "package" ]
        [ "programs" "nix-ld" "systems" system "package" ]
      )
      (mkAliasOptionModule
        [ "programs" "nix-ld" "libraries" ]
        [ "programs" "nix-ld" "systems" system "libraries" ]
      )
    ];

  options.programs.nix-ld.systems = mkOption {
    default = { };
    description = ''
      Configure nix-ld for the given system. Documentation: <https://github.com/nix-community/nix-ld>
    '';
    type = types.attrsOf (
      types.submodule (
        { config, ... }:
        {
          options = {
            # Since the submodule is by default `{}`, we can default `enable`
            # to true
            enable = mkEnableOption "nix-ld for the given system" // {
              default = true;
              example = false;
            };
            package = mkPackageOption config.pkgs "nix-ld" { };

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
              description = ''
                Libraries that automatically become available to all programs. The
                default set includes common libraries.
              '';
              defaultText = literalExpression "baseLibraries derived from systemd and nix dependencies.";
              # We currently take all libraries from systemd and nix as the default.
              # Is there a better list?
              default = [
                config.pkgs.zlib
                config.pkgs.zstd
                config.pkgs.stdenv.cc.cc
                config.pkgs.curl
                config.pkgs.openssl
                config.pkgs.attr
                config.pkgs.libssh
                config.pkgs.bzip2
                config.pkgs.libxml2
                config.pkgs.acl
                config.pkgs.libsodium
                config.pkgs.util-linux
                config.pkgs.xz
                config.pkgs.systemd
              ];
            };
          };
        }
      )
    );
  };

  config =
    let
      systems = builtins.attrNames cfg;
      forSystem = f: map (system: f system cfg.${system}) systems;
      attrsForSystem = f: mergeAttrsList (forSystem f);
    in
    {
      environment =
        {
          systemPackages = forSystem nix-ld-libraries;
          pathsToLink = forSystem (system: cfg: "/${share-path system}");
          variables = attrsForSystem (
            system: cfg: {
              "NIX_LD_${builtins.replaceStrings [ "-" ] [ "_" ] system}" =
                "/run/current-system/sw/${share-path system}/lib/ld.so";
              "NIX_LD_LIBRARY_PATH_${builtins.replaceStrings [ "-" ] [ "_" ] system}" =
                "/run/current-system/sw/${share-path system}/lib";
            }
          );
        }
        // attrsForSystem (
          system: cfg: {
            ${cfg.ldso} = "${cfg.package}/libexec/nix-ld";
          }
        );
    };
}
