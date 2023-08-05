{ pkgs, lib, config, ... }:
let
  cfg = config.programs.nix-ld;

  nix-ld-libraries = pkgs.buildEnv {
    name = "lb-library-path";
    pathsToLink = [ "/lib" ];
    paths = map lib.getLib cfg.libraries;
    # TODO make glibc here configurable?
    postBuild = ''
      ln -s ${pkgs.stdenv.cc.bintools.dynamicLinker} $out/share/nix-ld/lib/ld.so
    '';
    extraPrefix = "/share/nix-ld";
    ignoreCollisions = true;
  };

  # We currently take all libraries from systemd and nix as the default.
  # Is there a better list?
  baseLibraries = with pkgs; [
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
in
{
  meta.maintainers = [ lib.maintainers.mic92 ];
  options.programs.nix-ld = {
    enable = lib.mkEnableOption (lib.mdDoc ''nix-ld, Documentation: <https://github.com/Mic92/nix-ld>'');
    package = lib.mkPackageOptionMD pkgs "nix-ld" { };
    libraries = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      description = lib.mdDoc "Libraries that automatically become available to all programs. The default set includes common libraries.";
      default = baseLibraries;
      defaultText = lib.literalExpression "baseLibraries derived from systemd and nix dependencies.";
    };
  };

  config = lib.mkIf config.programs.nix-ld.enable {
    systemd.tmpfiles.packages = [ cfg.package ];

    environment.systemPackages = [ nix-ld-libraries ];

    environment.pathsToLink = [ "/share/nix-ld" ];

    environment.variables = {
      NIX_LD = "/run/current-system/sw/share/nix-ld/lib/ld.so";
      NIX_LD_LIBRARY_PATH = "/run/current-system/sw/share/nix-ld/lib";
    };
  };
}
