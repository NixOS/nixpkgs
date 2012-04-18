{
  network.description = "NixOS EBS creator";
  
  machine =
    { config, pkgs, ... }:
    { deployment.targetEnv = "ec2";
      deployment.ec2.instanceType = "m1.small";
      deployment.ec2.keyPair = "eelco";
      deployment.ec2.securityGroups = [ "eelco-test" ];
      environment.systemPackages = [ pkgs.parted ];
      fileSystems = [];
    };
}
