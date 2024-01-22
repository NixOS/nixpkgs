{ config, lib, pkgs, ... }:

let

  cfg = config.boot.uki;

  inherit (pkgs.stdenv.hostPlatform) efiArch;

  format = pkgs.formats.ini { };
  ukifyConfig = format.generate "ukify.conf" cfg.settings;

in

{
  options = {

    boot.uki = {
      name = lib.mkOption {
        type = lib.types.str;
        description = lib.mdDoc "Name of the UKI";
      };

      version = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = config.system.image.version;
        defaultText = lib.literalExpression "config.system.image.version";
        description = lib.mdDoc "Version of the image or generation the UKI belongs to";
      };

      settings = lib.mkOption {
        type = format.type;
        description = lib.mdDoc ''
          The configuration settings for ukify. These control what the UKI
          contains and how it is built.
        '';
      };
    };

    system.boot.loader.ukiFile = lib.mkOption {
      type = lib.types.str;
      internal = true;
      description = lib.mdDoc "Name of the UKI file";
    };

  };

  config = {

    boot.uki.name = lib.mkOptionDefault (if config.system.image.id != null then
      config.system.image.id
    else
      "nixos");

    boot.uki.settings = lib.mkOptionDefault {
      UKI = {
        Linux = "${config.boot.kernelPackages.kernel}/${config.system.boot.loader.kernelFile}";
        Initrd = "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}";
        Cmdline = "init=${config.system.build.toplevel}/init ${toString config.boot.kernelParams}";
        Stub = "${pkgs.systemd}/lib/systemd/boot/efi/linux${efiArch}.efi.stub";
        Uname = "${config.boot.kernelPackages.kernel.modDirVersion}";
        OSRelease = "@${config.system.build.etc}/etc/os-release";
        # This is needed for cross compiling.
        EFIArch = efiArch;
      };
    };

    system.boot.loader.ukiFile =
      let
        name = config.boot.uki.name;
        version = config.boot.uki.version;
        versionInfix = if version != null then "_${version}" else "";
      in
      name + versionInfix + ".efi";

    system.build.uki = pkgs.runCommand config.system.boot.loader.ukiFile { } ''
      mkdir -p $out
      ${pkgs.buildPackages.systemdUkify}/lib/systemd/ukify build \
        --config=${ukifyConfig} \
        --output="$out/${config.system.boot.loader.ukiFile}"
    '';

    meta.maintainers = with lib.maintainers; [ nikstur ];

  };
}
