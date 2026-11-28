{
  pkgs,
  lib,
  ...
}:

let
  plannConfig = pkgs.writeText "calendar.yaml" ''
    default:
      caldav_url: http://xandikos.local/xandikos/
      caldav_user: xandikos
      caldav_pass: snakeOilPassword
  '';
in

pkgs.nixosTests.xandikos.extend {
  modules = [
    {
      nodes.xandikos_client =
        {
          nodes,
          ...
        }:
        {
          environment.systemPackages = [
            pkgs.plann
          ];

          networking.hosts.${nodes.xandikos_proxy.networking.primaryIPAddress} = [
            "xandikos.local"
          ];
        };

      testScript = lib.mkAfter /* py */ ''
        with subtest("plann through the proxy"):
          plann = "plann -c ${plannConfig}"
          xandikos_client.succeed(f"{plann} list-calendars")
          xandikos_client.succeed(f"{plann} add todo 'nixpkgs smoke test task'")
          xandikos_client.succeed(f"{plann} select --all list | grep 'nixpkgs smoke test task'")
      '';
    }
  ];
}
