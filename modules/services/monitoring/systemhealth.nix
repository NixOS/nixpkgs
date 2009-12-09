{config, pkgs, ...}:

with pkgs.lib;

let
  cfg = config.services.systemhealth;

  systemhealth = with pkgs; stdenv.mkDerivation {
    name = "systemhealth-1.0";
    src = fetchurl {
      url = "http://www.brianlane.com/software/systemhealth/src/systemhealth-1.0.tar.bz2";
      sha256 = "1q69lz7hmpbdpbz36zb06nzfkj651413n9icx0njmyr3xzq1j9qy";
    };
    buildInputs = [ python ];
    installPhase = ''
      ensureDir $out/bin
      cp system_health.py $out/bin
    '';
  };

  rrdDir = "/var/lib/health/rrd";
  htmlDir = "/var/lib/health/html";

  configFile = rrdDir + "/.syshealthrc";
  # The program will try to read $HOME/.syshealthrc, so we set the proper home.
  command = "HOME=${rrdDir} ${systemhealth}/bin/system_health.py";

  cronJob = ''
    */5 * * * * wwwrun ${command} --log
    5 * * * * wwwrun ${command} --graph
  '';

  nameEqualName = s: "${s} = ${s}";
  interfacesSection = concatStringsSep "\n" (map nameEqualName cfg.interfaces);

  driveLine = d: "${d.path} = ${d.name}";
  drivesSection = concatStringsSep "\n" (map driveLine cfg.drives);

in
{
  options = {
    services.systemhealth = {
      enable = mkOption {
        default = false;
        description = ''
          Enable the system health monitor and its generation of graphs.
        '';
      };

      urlPrefix = mkOption {
        default = "/health";
        description = ''
          The URL prefix under which the System Health web pages appear in httpd.
        '';
      };

      interfaces = mkOption {
        default = [ "lo" ];
        example = [ "lo" "eth0" "eth1" ];
        description = ''
          Interfaces to monitor (minimum one).
        '';
      };

      drives = mkOption {
        default = [ ];
        example = [ { name = "root"; path = "/"; } ];
        description = ''
          Drives to monitor.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.cron.systemCronJobs = [ cronJob ];

    system.activationScripts.systemhealth = fullDepEntry ''
      mkdir -p ${rrdDir} ${htmlDir}
      chown wwwrun.wwwrun ${rrdDir} ${htmlDir}

      cat >${configFile} << EOF
      [paths]
      rrdtool = ${pkgs.rrdtool}/bin/rrdtool
      loadavg_rrd = loadavg
      ps = /var/run/current-system/sw/bin/ps
      df = /var/run/current-system/sw/bin/df
      meminfo_rrd = meminfo
      uptime_rrd = uptime
      rrd_path = ${rrdDir}
      png_path = ${htmlDir}

      [processes]

      [interfaces]
      ${interfacesSection}

      [drives]
      ${drivesSection}

      [graphs]
      width = 400
      time = ['-3hours', '-32hours', '-8days', '-5weeks', '-13months']
      height = 100

      [external]

      EOF

      chown wwwrun.wwwrun ${configFile}

      ${pkgs.su}/bin/su -s "/bin/sh" -c "${command} --check" wwwrun
      ${pkgs.su}/bin/su -s "/bin/sh" -c "${command} --html" wwwrun
    '' [ "var" ];

    services.httpd.extraSubservices = [
      { function = f: {
          extraConfig = ''
            Alias ${cfg.urlPrefix} ${htmlDir}
            
            <Directory ${htmlDir}>
                Order allow,deny
                Allow from all
            </Directory>
          '';
        };
      }
    ];
  };
}
