{ pkgs, lib, config, ... }: with lib; {
  options = {
    password = mkOption {
      type = types.nullOr types.str;
      description = ''
        The WPA2 password of the connection.
        Note, that if you use this option, the password will be world-readable (because it's saved in the nix store)!
        See also userPassword as an alternative
      '';
    };
    userPassword = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = ''
        Set this to true if the password should not be stored in the nix store but
        instead be asked from the user the first time it's used.
        It might then be possible to store it in the user's keyring.
        This way, the password won't be world-readable as is the case when you use password.
      '';
    };
    ssid = mkOption {
      type = types.str;
      description = "the SSID";
    };
  };

  config = {
    assertions = [
      { assertion = !config.userPassword || !config.password;
        message = "If the password is stored in the user keyring, it can't be specified here"; }
    ];
    warnings = [ "this isn't implemented fully yet" ];

    id = mkDefault config.ssid;

    userPassword = mkIf (config.password != null) false;

    sections = {
      wifi = ''
        ssid=${config.ssid}
      '';

      wifi-security = mkMerge [
        (mkIf (config.password != null) (pkgs.runCommand config.id { inherit (config) ssid password; } ''
          echo key-mgmt=wpa-psk > $out
          ${pkgs.wpa_supplicant}/bin/wpa_passphrase $ssid $password | sed -e 's/\s//' | grep ^psk >> $out
        ''))
        (mkIf config.userPassword ''
          key-mgmt=wpa-psk
          psk-flags=1
        '')
      ];
    };
  };
}