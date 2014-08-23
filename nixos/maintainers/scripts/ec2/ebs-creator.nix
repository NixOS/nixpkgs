{
  network.description = "NixOS EBS creator";

  machine =
    { config, pkgs, resources, ... }:
    { deployment.targetEnv = "ec2";
      deployment.ec2.instanceType = "c3.large";
      deployment.ec2.securityGroups = [ "admin" ];
      deployment.ec2.ebsBoot = false;
      deployment.ec2.keyPair = resources.ec2KeyPairs.keypair.name;
      deployment.ec2.zone = "us-east-1e";
      environment.systemPackages = [ pkgs.parted ];
    };
}
