# This test runs seafile (and checks if it works)

let
  client = {config, pkgs, ...}: {
    virtualisation.memorySize = 256;

    environment.systemPackages = [ pkgs.seafile ];
  };
in import ./make-test.nix ({ pkgs, ...} : {
  name = "seafile";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ kampfschlaefer ];
  };

  nodes = {
    seafile = { config, pkgs, ... }: {
      virtualisation.memorySize = 512;
      services.seafile = {
        enable = true;
        serviceUrl = "http://seafile";
      };
      services.nginx = {
        enable = true;
        httpConfig = ''
        server {
          listen 80;
          server_name seafile;

          proxy_set_header X-Forwarded-For $remote_addr;

          location / {
              fastcgi_pass    127.0.0.1:8000;
              fastcgi_param   SCRIPT_FILENAME     $document_root$fastcgi_script_name;
              fastcgi_param   PATH_INFO           $fastcgi_script_name;

              fastcgi_param   SERVER_PROTOCOL     $server_protocol;
              fastcgi_param   QUERY_STRING        $query_string;
              fastcgi_param   REQUEST_METHOD      $request_method;
              fastcgi_param   CONTENT_TYPE        $content_type;
              fastcgi_param   CONTENT_LENGTH      $content_length;
              fastcgi_param   SERVER_ADDR         $server_addr;
              fastcgi_param   SERVER_PORT         $server_port;
              fastcgi_param   SERVER_NAME         $server_name;
              fastcgi_param   REMOTE_ADDR         $remote_addr;

              access_log      /var/lib/seafile/log/nginx-seahub.access.log;
              error_log       /var/lib/seafile/log/nginx-seahub.error.log;
              fastcgi_read_timeout 36000;
          }

          location /seafhttp {
              rewrite ^/seafhttp(.*)$ $1 break;
              proxy_pass http://127.0.0.1:8082;
              client_max_body_size 0;
              proxy_connect_timeout  36000s;
              proxy_read_timeout  36000s;
              proxy_send_timeout  36000s;
              send_timeout  36000s;
          }

          location /media {
              root /var/lib/seafile/seahub/media;
          }
        }
        '';
      };
      networking.firewall = {
        allowedTCPPorts = [ 80 ];
      };
    };
    client1 = client pkgs;
    client2 = client pkgs;
  };

  testScript = ''
    $seafile->start();
    $client1->start();
    $client2->start();

    subtest "startup", sub {
      $seafile->waitForUnit("ccnet.service");
      $seafile->waitForUnit("seafile.service");
      $seafile->waitForUnit("seahub.service");

      #$seafile->execute("systemctl status -n 300 -l ccnet >&2");
      #$seafile->execute("cat /var/lib/seafile/log/ccnet.log >&2");

      #$seafile->execute("systemctl status -n 300 -l seafile >&2");
      #$seafile->execute("cat /var/lib/seafile/log/seafile.log >&2");

      #$seafile->execute("systemctl status -n 300 -l seahub >&2");
      #$seafile->execute("ls -la /var/lib/seafile/log/ >&2");
      #$seafile->execute("cat /var/lib/seafile/log/seahub_error.log >&2");
      #$seafile->execute("cat /var/lib/seafile/log/seahub_access.log >&2");

      #$seafile->execute("systemctl status -n 300 -l nginx >&2");
      #$seafile->execute("journalctl -u nginx >&2");
      $seafile->succeed("systemctl is-active nginx >&2");
      $seafile->execute("netstat -l -n >&2");
    };

    subtest "client1 connect", sub {
      my $libid;

      $client1->waitForUnit("default.target");

      #$client1->succeed("seaf-cli --help >&2");
      #$client1->succeed("seaf-cli init --help >&2");
      $client1->succeed("seaf-cli init -d . >&2");
      $client1->succeed("seaf-cli start >&2");

      #$client1->succeed("seaf-cli config --help >&2");
      #$client1->succeed("seaf-cli list-remote --help >&2");
      $client1->succeed("seaf-cli list-remote -s http://seafile -u admin\@example.com -p seafile_password >&2");

      $libid = $client1->succeed("seaf-cli create -s http://seafile -n test01 -u admin\@example.com -p seafile_password -t \"first test library\"");
      $libid =~ s/^\s+|\s+$//g;

      $client1->succeed("seaf-cli list-remote -s http://seafile -u admin\@example.com -p seafile_password |grep test01");
      $client1->fail("seaf-cli list-remote -s http://seafile -u admin\@example.com -p seafile_password |grep test02");

      $client1->succeed("seaf-cli download -l $libid -s http://seafile -u admin\@example.com -p seafile_password -d . >&2");

      sleep 3;

      $client1->succeed("seaf-cli status |grep synchronized >&2");

      $client1->succeed("ls -la >&2");
      $client1->succeed("ls -la test01 >&2");

      $client1->execute("echo bla > test01/first_file");

      sleep 2;

      $client1->succeed("seaf-cli status |grep synchronized >&2");
    };

    subtest "client2 sync to", sub {
      my $libid;

      $client2->waitForUnit("default.target");

      $client2->succeed("seaf-cli init -d . >&2");
      $client2->succeed("seaf-cli start >&2");

      $client2->succeed("seaf-cli list-remote -s http://seafile -u admin\@example.com -p seafile_password >&2");

      $libid = $client2->succeed("seaf-cli list-remote -s http://seafile -u admin\@example.com -p seafile_password |grep test01 |cut -d\' \' -f 2");
      $libid =~ s/^\s+|\s+$//g;

      $client2->succeed("seaf-cli download -l $libid -s http://seafile -u admin\@example.com -p seafile_password -d . >&2");

      sleep 3;

      $client2->succeed("seaf-cli status |grep synchronized >&2");

      $client2->succeed("ls -la test01 >&2");

      $client2->succeed("[ `cat test01/first_file` = \"bla\" ]");

    };

    subtest "logs for debugging", sub {
      $seafile->execute("ls -la /var/lib/seafile/log/ >&2");
      $seafile->execute("cat /var/lib/seafile/log/seafile.log >&2");
      $seafile->execute("cat /var/lib/seafile/log/seahub_error.log >&2");
      $seafile->execute("cat /var/lib/seafile/log/seahub_access.log >&2");
      $seafile->execute("cat /var/lib/seafile/log/nginx-seahub.access.log >&2");
      $seafile->execute("cat /var/lib/seafile/log/nginx-seahub.error.log >&2");
      $seafile->execute("journalctl -u nginx >&2");
      $seafile->execute("hostname -f >&2");
    };
  '';
})
