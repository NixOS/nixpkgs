import ./make-test-python.nix ({ lib, pkgs, ... }:

{
  name = "opencanary";
  meta.maintainers = [ "James Adam" ];

  nodes = {
    machine = { ... }: {
      services = {
        opencanary = {
          enable = true;
          services = {
            ftp.enable = true;
            git.enable = true;
            mssql.enable = true;
            mysql.enable = true;
            ntp.enable = true;
            portscan.enable = true;
            rdp.enable = true;
            redis.enable = true;
            samba.enable = true;
            sip.enable = true;
            snmp.enable = true;
            ssh.enable = true;
            tcpBanner = {
                enable = true;
                banners.main.port = 8001;
            };
            telnet.enable = true;
            tftp.enable = true;
            vnc.enable = true;
            website = {
                enable = true;
                http.enable = true;
                http.proxy.enable = true;
                https.enable = true;
            };
          };
          settings = {
            logs = {
              enable = true;
              handlers.console.enable = true;
            };
          };
        };
        openssh.enable = false;
      };
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("opencanaryd")

    machine.wait_for_open_port(21)   # ftp
    machine.wait_for_open_port(9418) # git
    machine.wait_for_open_port(1433) # mssql
    machine.wait_for_open_port(3306) # mysql
    machine.wait_for_open_port(123)  # ntp
    machine.wait_for_open_port(3389) # rdp
    machine.wait_for_open_port(6379) # redis
    machine.wait_for_open_port(5060) # sip
    machine.wait_for_open_port(161)  # snmp
    machine.wait_for_open_port(22)   # ssh
    machine.wait_for_open_port(8001) # tcpBanner
    machine.wait_for_open_port(23)   # telnet
    machine.wait_for_open_port(69)   # tftp
    machine.wait_for_open_port(5000) # vnc
    machine.wait_for_open_port(80)   # http
    machine.wait_for_open_port(443)  # https
    machine.wait_for_open_port(8080) # http proxy
  '';
})
