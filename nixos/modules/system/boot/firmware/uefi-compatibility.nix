{ config, lib, pkgs, ... }:

with lib;

let
  supportedArchitecture =
    let platform = config.nixpkgs.stdenv.hostPlatform;
    in platform == "x86_64-linux" || platform == "i686-linux";
  suggestedUBoot = {
    "x86_64-linux" = pkgs.ubootQemuX86;
    "i686-linux" = pkgs.ubootQemuX86;
  }.${config.nixpkgs.stdenv.hostPlatform};
in
{
  meta = {
    maintainers = with maintainers; [ raitobezarius ];
    doc = ./uefi-compatibility.md;
  };

  options = {
    boot.firmware.uefi-compatibility = {
      enable = mkEnableOption "the UEFI compatibility layer shim with U-Boot";
      package = mkOption {
        type = types.package;
        defaultText = "if x86_64 or i686 then ubootQemuX86 else nothing";
        exampleText = "pkgs.ubootPine64";
        description = lib.mdDoc ''
          Provide an U-Boot package as a compatibility layer,
          by default, it aims to choose one based on your architecture,
          if it cannot make a sensible choice based on your
          architecture, you will need to provide it yourself.
        '';
      } // lib.optional supportedArchitecture { default = suggestedUBoot; };
    };
  };

  config = mkIf cfg.enable {

  };
}
