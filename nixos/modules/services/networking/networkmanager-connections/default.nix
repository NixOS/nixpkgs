{config, pkgs, lib, ...}: with lib; {
  imports = [ ./wifi.nix ../../../misc/assertions.nix ];

  options = {
    configfile = mkOption {
      type = types.path;
      example = ''
        writeText '''
          [connection]
          type=wifi
          id=${ssid}

          [wifi]
          ssid=SSID_NAME

          [wifi-security]
          key-mgmt=wpa-psk
          psk=PSK
        '''
      '';
      description = ''
        A path to a file with the configuration of a network connection
        which will be copied to /etc/NetworkManager/system-connections/__<id>
      '';
      internal = true;
    };

    id = mkOption {
      type = types.str;
      description = ''
        the identifier of this connection. This is also used as file path
      '';
    };

    type = mkOption {
      type = types.str;
      example = "wifi";
      default = "wifi";
      description = "the type of the connection";
    };

    sections = mkOption {
      type = types.nullOr (types.attrsOf (types.either types.path types.str));
      description = ''
        A set of sections in the configfile
        '';
    };
  };

  config = {
    configfile = let convert = name: content:
        let path = if types.path.check content then content else pkgs.writeText name content;
        in [ name path ];
      in mkIf (config.sections != null) (pkgs.runCommand config.id {
      cf = concatStringsSep " " (concatLists (mapAttrsToList convert config.sections));
    } ''
      echo -n "" > $out
      isHeader=1
      echo "$cf" 1>&2
      for val in $cf; do
        if [ $isHeader -eq 1 ]; then
          echo "[$val]" >> $out
        else
          cat $val >> $out
        fi
        isHeader=$((1-isHeader))
      done
    '');
    sections.connection = ''
      type=${config.type}
      id=${config.id}
    '';
  };
}