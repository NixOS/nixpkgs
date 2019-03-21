{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.geoip-updater;

  dbBaseUrl = "https://geolite.maxmind.com/download/geoip/database";

  randomizedTimerDelaySec = "3600";

  # Use writeScriptBin instead of writeScript, so that argv[0] (logged to the
  # journal) doesn't include the long nix store path hash. (Prefixing the
  # ExecStart= command with '@' doesn't work because we start a shell (new
  # process) that creates a new argv[0].)
  geoip-updater = pkgs.writeScriptBin "geoip-updater" ''
    #!${pkgs.runtimeShell}
    skipExisting=0
    debug()
    {
        echo "<7>$@"
    }
    info()
    {
        echo "<6>$@"
    }
    error()
    {
        echo "<3>$@"
    }
    die()
    {
        error "$@"
        exit 1
    }
    waitNetworkOnline()
    {
        ret=1
        for i in $(seq 6); do
            curl_out=$("${pkgs.curl.bin}/bin/curl" \
                --silent --fail --show-error --max-time 60 "${dbBaseUrl}" 2>&1)
            if [ $? -eq 0 ]; then
                debug "Server is reachable (try $i)"
                ret=0
                break
            else
                debug "Server is unreachable (try $i): $curl_out"
                sleep 10
            fi
        done
        return $ret
    }
    dbFnameTmp()
    {
        dburl=$1
        echo "${cfg.databaseDir}/.$(basename "$dburl")"
    }
    dbFnameTmpDecompressed()
    {
        dburl=$1
        echo "${cfg.databaseDir}/.$(basename "$dburl")" | sed 's/\.\(gz\|xz\)$//'
    }
    dbFname()
    {
        dburl=$1
        echo "${cfg.databaseDir}/$(basename "$dburl")" | sed 's/\.\(gz\|xz\)$//'
    }
    downloadDb()
    {
        dburl=$1
        curl_out=$("${pkgs.curl.bin}/bin/curl" \
            --silent --fail --show-error --max-time 900 -L -o "$(dbFnameTmp "$dburl")" "$dburl" 2>&1)
        if [ $? -ne 0 ]; then
            error "Failed to download $dburl: $curl_out"
            return 1
        fi
    }
    decompressDb()
    {
        fn=$(dbFnameTmp "$1")
        ret=0
        case "$fn" in
            *.gz)
                cmd_out=$("${pkgs.gzip}/bin/gzip" --decompress --force "$fn" 2>&1)
                ;;
            *.xz)
                cmd_out=$("${pkgs.xz.bin}/bin/xz" --decompress --force "$fn" 2>&1)
                ;;
            *)
                cmd_out=$(echo "File \"$fn\" is neither a .gz nor .xz file")
                false
                ;;
        esac
        if [ $? -ne 0 ]; then
            error "$cmd_out"
            ret=1
        fi
    }
    atomicRename()
    {
        dburl=$1
        mv "$(dbFnameTmpDecompressed "$dburl")" "$(dbFname "$dburl")"
    }
    removeIfNotInConfig()
    {
        # Arg 1 is the full path of an installed DB.
        # If the corresponding database is not specified in the NixOS config we
        # remove it.
        db=$1
        for cdb in ${lib.concatStringsSep " " cfg.databases}; do
            confDb=$(echo "$cdb" | sed 's/\.\(gz\|xz\)$//')
            if [ "$(basename "$db")" = "$(basename "$confDb")" ]; then
                return 0
            fi
        done
        rm "$db"
        if [ $? -eq 0 ]; then
            debug "Removed $(basename "$db") (not listed in services.geoip-updater.databases)"
        else
            error "Failed to remove $db"
        fi
    }
    removeUnspecifiedDbs()
    {
        for f in "${cfg.databaseDir}/"*; do
            test -f "$f" || continue
            case "$f" in
                *.dat|*.mmdb|*.csv)
                    removeIfNotInConfig "$f"
                    ;;
                *)
                    debug "Not removing \"$f\" (unknown file extension)"
                    ;;
            esac
        done
    }
    downloadAndInstall()
    {
        dburl=$1
        if [ "$skipExisting" -eq 1 -a -f "$(dbFname "$dburl")" ]; then
            debug "Skipping existing file: $(dbFname "$dburl")"
            return 0
        fi
        downloadDb "$dburl" || return 1
        decompressDb "$dburl" || return 1
        atomicRename "$dburl" || return 1
        info "Updated $(basename "$(dbFname "$dburl")")"
    }
    for arg in "$@"; do
        case "$arg" in
            --skip-existing)
                skipExisting=1
                info "Option --skip-existing is set: not updating existing databases"
                ;;
            *)
                error "Unknown argument: $arg";;
        esac
    done
    waitNetworkOnline || die "Network is down (${dbBaseUrl} is unreachable)"
    test -d "${cfg.databaseDir}" || die "Database directory (${cfg.databaseDir}) doesn't exist"
    debug "Starting update of GeoIP databases in ${cfg.databaseDir}"
    all_ret=0
    for db in ${lib.concatStringsSep " \\\n        " cfg.databases}; do
        downloadAndInstall "${dbBaseUrl}/$db" || all_ret=1
    done
    removeUnspecifiedDbs || all_ret=1
    if [ $all_ret -eq 0 ]; then
        info "Completed GeoIP database update in ${cfg.databaseDir}"
    else
        error "Completed GeoIP database update in ${cfg.databaseDir}, with error(s)"
    fi
    # Hack to work around systemd journal race:
    # https://github.com/systemd/systemd/issues/2913
    sleep 2
    exit $all_ret
  '';

in

{
  options = {
    services.geoip-updater = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable periodic downloading of GeoIP databases from
          maxmind.com. You might want to enable this if you, for instance, use
          ntopng or Wireshark.
        '';
      };

      interval = mkOption {
        type = types.str;
        default = "weekly";
        description = ''
          Update the GeoIP databases at this time / interval.
          The format is described in
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>.
          To prevent load spikes on maxmind.com, the timer interval is
          randomized by an additional delay of ${randomizedTimerDelaySec}
          seconds. Setting a shorter interval than this is not recommended.
        '';
      };

      databaseDir = mkOption {
        type = types.path;
        default = "/var/lib/geoip-databases";
        description = ''
          Directory that will contain GeoIP databases.
        '';
      };

      databases = mkOption {
        type = types.listOf types.str;
        default = [
          "GeoLiteCountry/GeoIP.dat.gz"
          "GeoIPv6.dat.gz"
          "GeoLiteCity.dat.xz"
          "GeoLiteCityv6-beta/GeoLiteCityv6.dat.gz"
          "asnum/GeoIPASNum.dat.gz"
          "asnum/GeoIPASNumv6.dat.gz"
          "GeoLite2-Country.mmdb.gz"
          "GeoLite2-City.mmdb.gz"
        ];
        description = ''
          Which GeoIP databases to update. The full URL is ${dbBaseUrl}/ +
          <literal>the_database</literal>.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    assertions = [
      { assertion = (builtins.filter
          (x: builtins.match ".*\\.(gz|xz)$" x == null) cfg.databases) == [];
        message = ''
          services.geoip-updater.databases supports only .gz and .xz databases.

          Current value:
          ${toString cfg.databases}

          Offending element(s):
          ${toString (builtins.filter (x: builtins.match ".*\\.(gz|xz)$" x == null) cfg.databases)};
        '';
      }
    ];

    users.users.geoip = {
      group = "root";
      description = "GeoIP database updater";
      uid = config.ids.uids.geoip;
    };

    systemd.timers.geoip-updater =
      { description = "GeoIP Updater Timer";
        partOf = [ "geoip-updater.service" ];
        wantedBy = [ "timers.target" ];
        timerConfig.OnCalendar = cfg.interval;
        timerConfig.Persistent = "true";
        timerConfig.RandomizedDelaySec = randomizedTimerDelaySec;
      };

    systemd.services.geoip-updater = {
      description = "GeoIP Updater";
      after = [ "network-online.target" "nss-lookup.target" ];
      wants = [ "network-online.target" ];
      preStart = ''
        mkdir -p "${cfg.databaseDir}"
        chmod 755 "${cfg.databaseDir}"
        chown geoip:root "${cfg.databaseDir}"
      '';
      serviceConfig = {
        ExecStart = "${geoip-updater}/bin/geoip-updater";
        User = "geoip";
        PermissionsStartOnly = true;
      };
    };

    systemd.services.geoip-updater-setup = {
      description = "GeoIP Updater Setup";
      after = [ "network-online.target" "nss-lookup.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      conflicts = [ "geoip-updater.service" ];
      preStart = ''
        mkdir -p "${cfg.databaseDir}"
        chmod 755 "${cfg.databaseDir}"
        chown geoip:root "${cfg.databaseDir}"
      '';
      serviceConfig = {
        ExecStart = "${geoip-updater}/bin/geoip-updater --skip-existing";
        User = "geoip";
        PermissionsStartOnly = true;
        # So it won't be (needlessly) restarted:
        RemainAfterExit = true;
      };
    };

  };
}
