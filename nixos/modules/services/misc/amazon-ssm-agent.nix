{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  cfg = config.services.amazon-ssm-agent;

  # The SSM agent doesn't pay attention to our /etc/os-release yet, and the lsb-release tool
  # in nixpkgs doesn't seem to work properly on NixOS, so let's just fake the two fields SSM
  # looks for. See https://github.com/aws/amazon-ssm-agent/issues/38 for upstream fix.
  fake-lsb-release = pkgs.writeScriptBin "lsb_release" ''
    #!${pkgs.runtimeShell}

    case "$1" in
      -i) echo "nixos";;
      -r) echo "${config.system.nixos.version}";;
    esac
  '';

  sudoRule = {
    users = [ "ssm-user" ];
    commands = [
      {
        command = "ALL";
        options = [ "NOPASSWD" ];
      }
    ];
  };
in
{
  imports = [
    (mkRenamedOptionModule
      [
        "services"
        "ssm-agent"
        "enable"
      ]
      [
        "services"
        "amazon-ssm-agent"
        "enable"
      ]
    )
    (mkRenamedOptionModule
      [
        "services"
        "ssm-agent"
        "package"
      ]
      [
        "services"
        "amazon-ssm-agent"
        "package"
      ]
    )
  ];

  options.services.amazon-ssm-agent = {
    enable = mkEnableOption "Amazon SSM agent";
    package = mkPackageOption pkgs "amazon-ssm-agent" { };
  };

  config = mkIf cfg.enable {
    # See https://github.com/aws/amazon-ssm-agent/blob/mainline/packaging/linux/amazon-ssm-agent.service
    systemd.services.amazon-ssm-agent = {
      inherit (cfg.package.meta) description;
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [
        fake-lsb-release
        pkgs.coreutils
      ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/amazon-ssm-agent";
        KillMode = "process";
        # We want this restating pretty frequently. It could be our only means
        # of accessing the instance.
        Restart = "always";
        RestartPreventExitStatus = 194;
        RestartSec = "90";
      };
    };

    # Add user that Session Manager needs, and give it sudo.
    # This is consistent with Amazon Linux 2 images.
    security.sudo.extraRules = [ sudoRule ];
    security.sudo-rs.extraRules = [ sudoRule ];

    # On Amazon Linux 2 images, the ssm-user user is pretty much a
    # normal user with its own group. We do the same.
    users.groups.ssm-user = { };
    users.users.ssm-user = {
      isNormalUser = true;
      group = "ssm-user";
    };

    environment.etc."amazon/ssm/seelog.xml".source = "${cfg.package}/etc/amazon/ssm/seelog.xml.template";

    environment.etc."amazon/ssm/amazon-ssm-agent.json".source = "${cfg.package}/etc/amazon/ssm/amazon-ssm-agent.json.template";

  };
}
