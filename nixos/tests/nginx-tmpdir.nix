let
  dst-dir = "/run/nginx-test-tmpdir-uploads";
in
{ ... }:
{
  name = "nginx-tmpdir";

  nodes.machine =
    { pkgs, ... }:
    {
      environment.etc."tmpfiles.d/nginx-uploads.conf".text = "d ${dst-dir} 0755 nginx nginx 1d";

      # overwrite the tmp.conf with a short age, there will be a duplicate line info from systemd-tmpfiles in the log
      systemd.tmpfiles.rules = [
        "q /tmp 1777 root root 1min"
      ];

      services.nginx.enable = true;
      # simple upload service using the nginx client body temp path
      services.nginx.virtualHosts = {
        localhost = {
          locations."~ ^/upload/([0-9a-zA-Z-.]*)$" = {
            extraConfig = ''
              alias ${dst-dir}/$1;
              client_body_in_file_only clean;
              dav_methods PUT;
              create_full_put_path on;
              dav_access group:rw all:r;
            '';
          };
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("nginx")
    machine.wait_for_open_port(80)

    with subtest("Needed prerequisite --http-client-body-temp-path=/tmp/nginx_client_body and private temp"):
      machine.succeed("touch /tmp/systemd-private-*-nginx.service-*/tmp/nginx_client_body")

    with subtest("Working upload of test setup"):
      machine.succeed("curl -X PUT http://localhost/upload/test1 --fail --data-raw 'Raw data 1'")
      machine.succeed('test "$(cat ${dst-dir}/test1)" = "Raw data 1"')

    # let the tmpfiles clean service do its job
    machine.succeed("touch /tmp/touched")
    machine.wait_until_succeeds(
      "sleep 15 && systemctl start systemd-tmpfiles-clean.service && [ ! -f /tmp/touched ]",
      timeout=150
    )

    with subtest("Working upload after cleaning"):
      machine.succeed("curl -X PUT http://localhost/upload/test2 --fail --data-raw 'Raw data 2'")
      machine.succeed('test "$(cat ${dst-dir}/test2)" = "Raw data 2"')

    # manually remove the nginx temp dir
    machine.succeed("rm -r --interactive=never /tmp/systemd-private-*-nginx.service-*/tmp/nginx_client_body")

    with subtest("Broken upload after manual temp dir removal"):
      machine.fail("curl -X PUT http://localhost/upload/test3 --fail --data-raw 'Raw data 3'")
  '';
}
