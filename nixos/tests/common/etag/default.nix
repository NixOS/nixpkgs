{ name, serverConfig }:

import ../../make-test-python.nix {
  inherit name;

  nodes = {
    server = { lib, pkgs, config, ... } @ args: with lib; {
      options.test-support.etag.root = mkOption {
        default = ./test-1;
      };

      imports = [
        (serverConfig args)
      ];

      config = {
        specialisation.test-2.configuration = {
          test-support.etag.root = ./test-2;
        };

        networking.firewall.allowedTCPPorts = [ 80 ];

    };
  };

  testScript = { nodes, ... }: let
    inherit (nodes.server.system.build) toplevel;
  in ''
    start_all()

    server.wait_for_unit("multi-user.target")

    def check_etag(url):
        etag = server.succeed(
            "curl --fail -v '{}' 2>&1 | sed -n -e \"s/^< etag: *//ip\"".format(
                url
            )
        )
        etag = etag.strip()
        http_code = server.succeed(
            "curl --fail --silent --show-error -o /dev/null -w \"%{{http_code}}\" --head -H 'If-None-Match: {}' {}".format(
                etag, url
            )
        )
        assert int(http_code) == 304, "HTTP code is {}, expected 304".format(http_code)
        return etag

    with subtest("check ETag if serving Nix store paths"):
        first_etag = check_etag("http://server/index.txt")
        server.succeed(
            "${toplevel}/specialisation/test-2/bin/switch-to-configuration test"
        )
        second_etag = check_etag("http://server/index.txt")
        assert first_etag != second_etag, "ETags are the same"
  '';
}
