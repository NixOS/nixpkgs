{ pkgs, lib, config, ... }:
let
  suffixes = [ "nix-ld" "nix-ld-32" ];
  variant = name: {
    inherit name;
    pkgs = { "nix-ld" = pkgs; "nix-ld-32" = pkgs.pkgsi686Linux; }.${name};
    ldso = { "nix-ld" = "ldso"; "nix-ld-32" = "ldso32"; }.${name};
    cfg = config.programs."${name}";
  };

  nix-ld-libraries = name: cfg: pkgs: pkgs.buildEnv {
    name = "ld-library-path";
    pathsToLink = [ "/lib" ];
    paths = map lib.getLib cfg.libraries;
    # TODO make glibc here configurable?
    postBuild = ''
      ln -s ${pkgs.stdenv.cc.bintools.dynamicLinker} $out/share/${name}/lib/ld.so
    '';
    extraPrefix = "/share/${name}";
    ignoreCollisions = true;
  };
in
{
  meta.maintainers = [ lib.maintainers.mic92 ];
  options.programs = lib.genAttrs suffixes (suffix:
    let inherit (variant suffix) name cfg pkgs; in {
      enable = lib.mkEnableOption ''nix-ld, Documentation: <https://github.com/Mic92/nix-ld>'';
      package = lib.mkPackageOption pkgs "nix-ld" { };
      libraries = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        description = "Libraries that automatically become available to all programs. The default set includes common libraries.";
        default = [ ];
        defaultText = lib.literalExpression "baseLibraries derived from systemd and nix dependencies.";
      };
    });

  config = lib.mkMerge (lib.forEach suffixes (suffix:
    let inherit (variant suffix) name cfg pkgs ldso; in lib.mkIf config.programs.${name}.enable {
      environment.${ldso} = "${cfg.package}/libexec/nix-ld";

      environment.systemPackages = [ (nix-ld-libraries name cfg pkgs) ];

      environment.pathsToLink = [ "/share/${name}" ];

      environment.variables = {
        "NIX_LD_${builtins.replaceStrings ["-"] ["_"] pkgs.system}" = "/run/current-system/sw/share/${name}/lib/ld.so";
        "NIX_LD_LIBRARY_PATH_${builtins.replaceStrings ["-"] ["_"] pkgs.system}" = "/run/current-system/sw/share/${name}/lib";
      };

      # We currently take all libraries from systemd and nix as the default.
      # Is there a better list?
      programs.nix-ld.libraries = with pkgs; [
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
    }));
}
