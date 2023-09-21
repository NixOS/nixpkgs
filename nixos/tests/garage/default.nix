{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
}:
with pkgs.lib;

let
    mkNode = package: { replicationMode, publicV6Address ? "::1" }: { pkgs, ... }: {
      networking.interfaces.eth1.ipv6.addresses = [{
        address = publicV6Address;
        prefixLength = 64;
      }];

      networking.firewall.allowedTCPPorts = [ 3901 3902 ];

      services.garage = {
        enable = true;
        inherit package;
        settings = {
          replication_mode = replicationMode;

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
        };
      };
      environment.systemPackages = [ pkgs.minio-client ];

      # Garage requires at least 1GiB of free disk space to run.
      virtualisation.diskSize = 2 * 1024;
    };
in
  foldl
  (matrix: ver: matrix // {
    "basic${toString ver}" = import ./basic.nix { inherit system pkgs; mkNode = mkNode pkgs."garage_${ver}"; };
    "with-3node-replication${toString ver}" = import ./with-3node-replication.nix { inherit system pkgs; mkNode = mkNode pkgs."garage_${ver}"; };
  })
  {}
  [
    "0_8"
  ]
