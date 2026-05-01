{ pkgs, lib, ... }:

let
  testOnlySSHCredentials =
    pkgs.runCommand "pam-ussh-test-ca"
      {
        nativeBuildInputs = [ pkgs.openssh ];
      }
      ''
        mkdir $out
        ssh-keygen -t ed25519 -N "" -f $out/ca

        ssh-keygen -t ed25519 -N "" -f $out/alice
        ssh-keygen -s $out/ca -I "alice user key" -n "alice,root" -V 19700101:forever $out/alice.pub

        ssh-keygen -t ed25519 -N "" -f $out/bob
        ssh-keygen -s $out/ca -I "bob user key" -n "bob" -V 19700101:forever $out/bob.pub
      '';
  makeTestScript =
    user:
    pkgs.writeShellScript "pam-ussh-${user}-test-script" ''
      set -euo pipefail

      eval $(${pkgs.openssh}/bin/ssh-agent)

      mkdir -p $HOME/.ssh
      chmod 700 $HOME/.ssh
      cp ${testOnlySSHCredentials}/${user}{,.pub,-cert.pub} $HOME/.ssh
      chmod 600 $HOME/.ssh/${user}
      chmod 644 $HOME/.ssh/${user}{,-cert}.pub

      set -x

      ${pkgs.openssh}/bin/ssh-add $HOME/.ssh/${user}
      ${pkgs.openssh}/bin/ssh-add -l &>2

      exec sudo id -u -n
    '';
in
{
  name = "pam-ussh";
  meta.maintainers = with lib.maintainers; [ lukegb ];

  machine =
    { ... }:
    {
      users.users.alice = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };
      users.users.bob = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
      };

      security.pam.ussh = {
        enable = true;
        authorizedPrincipals = "root";
        caFile = "${testOnlySSHCredentials}/ca.pub";
      };

      security.sudo = {
        enable = true;
        extraConfig = ''
          Defaults lecture="never"
        '';
      };
    };

  testScript = ''
    with subtest("alice should be allowed to escalate to root"):
      machine.succeed(
          'su -c "${makeTestScript "alice"}" -l alice | grep root'
      )

    with subtest("bob should not be allowed to escalate to root"):
      machine.fail(
          'su -c "${makeTestScript "bob"}" -l bob | grep root'
      )
  '';
}
