{ pkgs, ... }:
{
  name = "svnserve";

  nodes = {
    server = {
      virtualisation.vlans = [ 1 ];

      networking = {
        useNetworkd = true;
        useDHCP = false;
        firewall.allowedTCPPorts = [ 3690 ];
      };

      systemd.network.networks."01-eth1" = {
        name = "eth1";
        networkConfig.Address = "10.0.0.1/24";
      };

      services.svnserve.enable = true;

      environment.systemPackages = [ pkgs.subversion ];
    };

    client =
      { pkgs, ... }:
      {
        virtualisation.vlans = [ 1 ];

        networking = {
          useNetworkd = true;
          useDHCP = false;
        };

        systemd.network.networks."01-eth1" = {
          name = "eth1";
          networkConfig.Address = "10.0.0.2/24";
        };

        environment.systemPackages = [ pkgs.subversion ];
      };
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      server.wait_for_unit("svnserve")
      server.wait_for_open_port(3690)
      server.succeed("svnadmin create '${nodes.server.services.svnserve.svnBaseDir}/project'")
      server.succeed("sed -i 's/# anon-access = read/anon-access = write/' '${nodes.server.services.svnserve.svnBaseDir}/project/conf/svnserve.conf'")

      client.succeed("svn checkout svn://10.0.0.1/project")
      client.succeed("cd ./project && echo hello > ./file.txt && svn add ./file.txt && svn commit -m 'Added file.txt'")

      client.succeed("svn checkout svn://10.0.0.1/project project-copy")
      client.succeed("grep hello project-copy/file.txt")
    '';
}
