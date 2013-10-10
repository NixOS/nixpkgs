{
  network.description = "NixOS EBS creator";

  machine =
    { config, pkgs, resources, ... }:
    { deployment.targetEnv = "ec2";
      deployment.ec2.instanceType = "m1.large";
      deployment.ec2.securityGroups = [ "admin" ];
      deployment.ec2.ebsBoot = false;
      deployment.ec2.keyPair = resources.ec2KeyPairs.keypair.name;
      environment.systemPackages = [ pkgs.parted ];
    };
}
