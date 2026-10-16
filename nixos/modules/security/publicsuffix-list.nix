{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.networking.publicSuffixList;
in
{
  options.networking.publicSuffixList = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to install the public suffix list at
        {file}`/etc/publicsuffix/public_suffix_list.dafsa`, where libpsl loads
        it at runtime.

        If disabled, programs using libpsl will fall back to the copy compiled
        into the library, which is only updated when libpsl itself is.
      '';
    };

    package = lib.mkPackageOption pkgs "publicsuffix-list-dafsa" { };
  };

  config = lib.mkIf cfg.enable {
    # libpsl relies on file timestamps to decide whether to use the dist list
    # so we cannot symlink to the store here because the timestamp would be EPOCH
    environment.etc."publicsuffix/public_suffix_list.dafsa" = {
      source = "${cfg.package}/share/publicsuffix/public_suffix_list.dafsa";
      mode = "0444";
    };
  };
}
