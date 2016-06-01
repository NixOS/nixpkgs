{ config, lib, pkgs, ... }:

with lib;

let cfg = config.programs.unity3d;
in {

  options = {
    programs.unity3d.enable = mkEnableOption "Unity3D, a game development tool";
  };

  config = mkIf cfg.enable {
    security.setuidOwners = [{
      program = "unity-chrome-sandbox";
      source = "${pkgs.unity3d.sandbox}/bin/unity-chrome-sandbox";
      owner = "root";
      #group = "root";
      setuid = true;
      #setgid = true;
    }];

    environment.systemPackages = [ pkgs.unity3d ];
  };

}
