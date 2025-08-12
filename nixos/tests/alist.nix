{ lib, ... }:
let
  certs = import ./common/acme/server/snakeoil-certs.nix;
  domain = certs.domain;
in
{
  name = "alist";

  meta.maintainers = with lib.maintainers; [ moraxyc ];

  nodes.machine =
    { pkgs, ... }:
    {
      security.pki.certificateFiles = [ certs.ca.cert ];
      environment.systemPackages = with pkgs; [
        curl
        alist
        sudo
      ];
      networking.hosts = {
        "::1" = [ domain ];
      };
      services.alist = {
        enable = true;
        mutableConfig = true;
        settings = {
          scheme = {
            # Test CAP_NET_BIND_SERVICE
            https_port = 443;
            http_port = 5244;
            cert_file = certs.${domain}.cert;
            key_file = certs.${domain}.key;
          };
        };
      };
    };

  testScript = ''
    import json

    machine.wait_for_unit("alist.service")

    # Test mutableConfig
    with subtest("mutableConfig"):
        machine.succeed("systemctl stop alist")
        machine.succeed("""
            echo '{"scheme": {"force_https": true}}' > /var/lib/alist/config.json
        """)
        machine.succeed("systemctl start alist")
        machine.wait_for_unit("alist.service")
        # Verify
        result = json.loads(machine.succeed("cat /var/lib/alist/config.json"))
        assert result['scheme']['force_https'] is True
        machine.wait_for_open_port(5244)
        machine.wait_for_open_port(443)
        assert "https://${domain}" in machine.succeed("curl -I http://${domain}:5244/")

    with subtest("Ping"):
        assert "pong" in machine.succeed("curl --fail --max-time 10 http://${domain}:5244/ping")
        assert "pong" in machine.succeed("curl --fail --max-time 10 https://${domain}/ping")

    # Set admin password
    machine.succeed("alist admin set password --data /var/lib/alist")

    with subtest("Get token"):
        result = json.loads(machine.succeed("""
            curl --fail -X POST --json '{ "username": "admin", "password": "password"}' \
            https://${domain}/api/auth/login
        """))
        token = result['data']['token']

    with subtest("Add local storage"):
        machine.succeed("sudo -ualist mkdir -p /var/lib/alist/storage1")
        result = machine.succeed("""
          curl --fail -X POST --header 'Authorization: %s' \
              --json '{
                "mount_path": "/storage1",
                "order": 0,
                "remark": "",
                "cache_expiration": 30,
                "web_proxy": false,
                "webdav_policy": "native_proxy",
                "down_proxy_url": "",
                "extract_folder": "front",
                "enable_sign": false,
                "driver": "Local",
                "order_by": "name",
                "order_direction": "asc",
                "addition": "{\\"root_folder_path\\":\\"/var/lib/alist/storage1\\",\\"thumbnail\\":false,\\"thumb_cache_folder\\":\\"\\",\\"show_hidden\\":true,\\"mkdir_perm\\":\\"777\\"}"
              }' 'https://${domain}/api/admin/storage/create'
        """ % token)

    with subtest("Upload and Download"):
        machine.succeed(f"""
          echo HelloWorld > /tmp/hello
          curl -X PUT --form 'file=@/tmp/hello' \
            --header 'Authorization: {token}' \
            --header 'File-Path: %2Fstorage1%2Fhello' \
            --header 'As-Task: false' \
            'https://${domain}/api/fs/form'
        """)
        result = json.loads(machine.succeed("""
          curl -X POST --header 'Authorization: %s' \
            --json '{
                "path": "/storage1/hello",
                "password": "",
                "page": 1,
                "per_page": 0,
                "refresh": false
              }' 'https://${domain}/api/fs/get'
        """ % token))
        sign = result['data']['sign']
        assert "HelloWorld" in machine.succeed("curl --fail 'https://${domain}/d/storage1/hello?sign=%s'" % sign)

        # Verify local file
        assert "HelloWorld" in machine.succeed("cat /var/lib/alist/storage1/hello")
  '';
}
