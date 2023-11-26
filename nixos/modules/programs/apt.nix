{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.apt;
in

{
  meta.maintainers = [ maintainers.MakiseKurisu ];

  ###### interface
  options.programs.apt = {
    enable = mkEnableOption (mdDoc ''
      Whether to enable {command}`apt`, the package manager for Debian-based systems.

      Please be aware that this option **DOES NOT** enable {command}`apt` as a
      package manager on NixOS. It is mainly to allow programs to use {command}`apt`
      to work on Debian-based root file systems.
    '');

    package = mkOption {
      type = types.package;
      default = pkgs.apt;
      defaultText = literalExpression "pkgs.apt";
      description = mdDoc ''
        {command}`apt` package to use.
      '';
    };

    keyringPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
          debian-archive-keyring
      ];
      defaultText = literalExpression ''
        with pkgs; [
          debian-archive-keyring
        ];
      '';
      description = mdDoc ''
        Archive keyring packages for {command}`apt`.

        Packages specified here will have its `/etc/apt/trusted.gpg.d` content symbolic
        linked in the rootfs, so {command}`apt` could use them to verify the archive
        content.
      '';
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    users.users._apt = {
      isSystemUser = true;
      group = "nogroup";
    };
    environment.etc =
      let
        trusted = pkgs: map (p: "${getBin p}/etc/apt/trusted.gpg.d") pkgs;
        buildEtc = p: attrsets.concatMapAttrs (n: v: {
          "apt/trusted.gpg.d/${n}" = {
            source = "${p}/${n}";
          };
        }) (builtins.readDir p);
        buildEtcForEach = t: map buildEtc t;
        keyrings = pkgs: attrsets.mergeAttrsList (buildEtcForEach (trusted pkgs));
      in
      keyrings cfg.keyringPackages;
  };
}
