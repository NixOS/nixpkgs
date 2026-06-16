{
  lib,
  ...
}:

{
  name = "liberaforms";
  meta.maintainers = lib.teams.ngi.members;

  nodes = {
    machine =
      { pkgs, ... }:
      {
        imports = [
          {
            services.liberaforms = {
              enable = true;
              openFirewall = true;

              reverseProxy = {
                enable = true;
                ssl = false;
                host = "liberaforms.test";
              };

              secrets.keyFile = "/etc/liberaforms-secret";

              settings = {
                ROOT_USER = "ngi@nixos.org";
                SESSION_TYPE = "filesystem";
                TOKEN_EXPIRATION = 604800;
                DEFAULT_TIMEZONE = "Asia/Shanghai";
                TOTAL_UPLOADS_LIMIT = "1 GB";
                DEFAULT_USER_UPLOADS_LIMIT = "50 MB";
                ENABLE_REMOTE_STORAGE = false;
                MAX_MEDIA_SIZE = 512000;
                MAX_ATTACHMENT_SIZE = 1572864;
                ENABLE_PROMETHEUS_METRICS = false;
                ENABLE_RSS_FEED = false;
                DEFAULT_LANGUAGE = "en-US";
              };
            };

            networking.extraHosts = ''
              127.0.0.1 liberaforms.test
            '';
          }
        ];

        # WARN: Don't use this module in production as it will copy the secret
        # to the world-readable Nix store.
        environment.etc."liberaforms-secret".text = "a_secret_key";
      };
  };

  testScript =
    { nodes, ... }:
    let
      cfg = nodes.machine.services.liberaforms;
    in
    # python
    ''
      start_all()
      machine.wait_for_unit("multi-user.target")

      machine.wait_for_unit("liberaforms.service")
      machine.wait_until_succeeds("curl --fail http://0.0.0.0:${toString cfg.port}/")

      machine.wait_for_unit("nginx.service")
      machine.wait_until_succeeds(
          "curl --fail --resolve liberaforms.test:80:127.0.0.1 ${cfg.settings.BASE_URL}"
      )
      machine.succeed(
          "curl -sI --resolve liberaforms.test:80:127.0.0.1 ${cfg.settings.BASE_URL}"
          " | grep -qi 'x-frame-options: SAMEORIGIN'"
      )
    '';

  # Debug interactively with:
  # - nix run -f . nixosTests.liberaforms.driverInteractive -L
  # - run_tests()
  interactive.sshBackdoor.enable = true;
  interactive.nodes.machine =
    { config, ... }:
    {
      virtualisation.forwardPorts = [
        {
          from = "host";
          host.port = config.services.liberaforms.port;
          guest.port = config.services.liberaforms.port;
        }
      ];
    };
}
