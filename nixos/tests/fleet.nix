import ./make-test.nix rec {
  name = "simple";

  nodes = {
    node1 =
      { config, pkgs, ... }:
        {
          services = {
            etcd = {
              enable = true;
              listenPeerUrls = ["http://0.0.0.0:7001"];
              initialAdvertisePeerUrls = ["http://node1:7001"];
              initialCluster = ["node1=http://node1:7001" "node2=http://node2:7001"];
            };
         };

          services.fleet = {
            enable = true;
            metadata.name = "node1";
          };

          networking.firewall.allowedTCPPorts = [ 7001 ];
        };

    node2 =
      { config, pkgs, ... }:
        {
          services = {
            etcd = {
              enable = true;
              listenPeerUrls = ["http://0.0.0.0:7001"];
              initialAdvertisePeerUrls = ["http://node2:7001"];
              initialCluster = ["node1=http://node1:7001" "node2=http://node2:7001"];
            };
           };

          services.fleet = {
            enable = true;
            metadata.name = "node2";
          };

          networking.firewall.allowedTCPPorts = [ 7001 ];
        };
  };

  service = builtins.toFile "hello.service" ''
    [Unit]
    Description=Hello World

    [Service]
    ExecStart=/bin/sh -c "while true; do echo \"Hello, world\"; /var/run/current-system/sw/bin/sleep 1; done"

    [X-Fleet]
    MachineMetadata=name=node2
  '';

  testScript =
    ''
      startAll;
      $node1->waitForUnit("fleet.service");
      $node2->waitForUnit("fleet.service");

      $node2->waitUntilSucceeds("fleetctl list-machines | grep node1");
      $node1->waitUntilSucceeds("fleetctl list-machines | grep node2");

      $node1->succeed("cp ${service} hello.service && fleetctl submit hello.service");
      $node1->succeed("fleetctl list-unit-files | grep hello");
      $node1->succeed("fleetctl start hello.service");
      $node1->waitUntilSucceeds("fleetctl list-units | grep running");
      $node1->succeed("fleetctl stop hello.service");
      $node1->succeed("fleetctl destroy hello.service");
    '';
}
