{
  runTest,
  package,
}:
let
  mkNode =
    {
      publicV6Address ? "::1",
      extraSettings ? { },
    }:
    { pkgs, ... }:
    {
      networking.interfaces.eth1.ipv6.addresses = [
        {
          address = publicV6Address;
          prefixLength = 64;
        }
      ];

      networking.firewall.allowedTCPPorts = [
        3901
        3902
      ];

      services.garage = {
        enable = true;
        inherit package;
        settings = {
          rpc_bind_addr = "[::]:3901";
          rpc_public_addr = "[${publicV6Address}]:3901";
          rpc_secret = "5c1915fa04d0b6739675c61bf5907eb0fe3d9c69850c83820f51b4d25d13868c";

          s3_api = {
            s3_region = "garage";
            api_bind_addr = "[::]:3900";
            root_domain = ".s3.garage";
          };

          s3_web = {
            bind_addr = "[::]:3902";
            root_domain = ".web.garage";
            index = "index.html";
          };
        }
        // extraSettings;
      };
      environment.systemPackages = [ pkgs.minio-client ];

      # Garage requires at least 1GiB of free disk space to run.
      virtualisation.diskSize = 2 * 1024;
    };
in
{
  basic = runTest {
    imports = [
      ./common.nix
      ./basic.nix
    ];
    _module.args = {
      inherit mkNode package;
    };
  };

  with-3node-replication = runTest {
    imports = [
      ./common.nix
      ./with-3node-replication.nix
    ];
    _module.args = {
      inherit mkNode package;
    };
  };
}
