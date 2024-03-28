{ config, lib, pkgs, ... }:

let
  cfg = config.programs.apt;
in

{
  meta.maintainers = with lib.maintainers; [ MakiseKurisu ];

  ###### interface
  options.programs.apt = {
    enable = lib.mkEnableOption (lib.mdDoc ''
      Whether to enable {command}`apt`, the package manager for Debian-based systems.

      Please be aware that this option **DOES NOT** enable {command}`apt` as a
      package manager on NixOS. It is mainly to allow programs to use {command}`apt`
      to work on Debian-based root file systems.
    '');

    package = lib.mkOption {
      type = with lib; with types; package;
      default = pkgs.apt;
      defaultText = lib.literalExpression "pkgs.apt";
      description = lib.mdDoc ''
        {command}`apt` package to use.
      '';
    };

    keyringPackages = lib.mkOption {
      type = with lib; with types; listOf package;
      default = with pkgs; [
          debian-archive-keyring
      ];
      defaultText = lib.literalExpression ''
        with pkgs; [
          debian-archive-keyring
        ];
      '';
      description = lib.mdDoc ''
        Archive keyring packages for {command}`apt`.

        Packages specified here will have its `/etc/apt/trusted.gpg.d` content symbolic
        linked in the rootfs, so {command}`apt` could use them to verify the archive
        content.
      '';
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    users.users._apt = {
      isSystemUser = true;
      group = "nogroup";
    };
    environment.etc =
      let
        trusted = pkgs: map (p: "${lib.getBin p}/etc/apt/trusted.gpg.d") pkgs;
        buildEtc = p: lib.attrsets.concatMapAttrs (n: v: {
          "apt/trusted.gpg.d/${n}" = {
            source = "${p}/${n}";
          };
        }) (builtins.readDir p);
        buildEtcForEach = t: map buildEtc t;
        keyrings = pkgs: lib.attrsets.mergeAttrsList (buildEtcForEach (trusted pkgs));
      in
      keyrings cfg.keyringPackages;
  };
}
