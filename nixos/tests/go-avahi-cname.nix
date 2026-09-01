{
  lib,
  ...
}:
let
  avahi_config = {
    enable = true;
    nssmdns4 = true;
    nssmdnsFull = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
in
{
  name = "go-avahi-cname";

  meta.maintainers = with lib.maintainers; [ magicquark ];

  nodes = {
    machineIntervalPublishing = {
      services.avahi = avahi_config;

      services.go-avahi-cname = {
        enable = true;
        debug = true;
        mode = "interval-publishing";
        subdomains = [
          "paperless"
          "printer"
        ];
      };

      environment.etc."mdns.allow".text = ''
        .local.
        .local
      '';
    };
    machineSubdomainReply = {
      services.avahi = avahi_config;

      services.go-avahi-cname = {
        enable = true;
        debug = true;
        mode = "subdomain-reply";
      };

      environment.etc."mdns.allow".text = ''
        .local.
        .local
      '';
    };
  };

  testScript = ''
    machineIntervalPublishing.start()

    machineIntervalPublishing.wait_for_unit("avahi-daemon.service")
    machineIntervalPublishing.wait_for_unit("go-avahi-cname.service")

    hostname = machineIntervalPublishing.succeed("hostname").strip()
    machineIntervalPublishing.wait_until_succeeds(f"getent hosts paperless.{hostname}.local")
    machineIntervalPublishing.wait_until_succeeds(f"getent hosts printer.{hostname}.local")
    machineIntervalPublishing.wait_until_fails(f"getent hosts git.{hostname}.local")


    machineSubdomainReply.start()

    machineSubdomainReply.wait_for_unit("avahi-daemon.service")
    machineSubdomainReply.wait_for_unit("go-avahi-cname.service")

    hostname = machineSubdomainReply.succeed("hostname").strip()
    machineSubdomainReply.wait_until_succeeds(f"getent hosts git.{hostname}.local")
    machineSubdomainReply.wait_until_succeeds(f"getent hosts grafana.{hostname}.local")
  '';
}
