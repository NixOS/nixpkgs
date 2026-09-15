{ lib, ... }:
{
  name = "speechd";
  meta.maintainers = [ lib.maintainers.h7x4 ];

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ ./common/user-account.nix ];

      environment.systemPackages = [ pkgs.speechd ];

      # Without a real sound card, libao (speech-dispatcher's audio backend)
      # fails to open any device. libao's built-in "null" driver always succeeds.
      environment.etc."libao.conf".text = ''
        default_driver=null
      '';

      services.speechd = {
        enable = true;
        config = ''
          AddModule "testmodule" "sd_generic" "testmodule.conf"
          DefaultModule "testmodule"
        '';
        modules.testmodule = ''
          AddVoice "en" "male1" "testmodule_voice"
          GenericLanguage "en" "en"
          GenericExecuteSynth "echo \'$DATA\' >> /tmp/speechd-spoken.txt"
        '';
      };
    };

  testScript =
    { nodes, ... }:
    let
      user = nodes.machine.users.users.alice;
      uid = toString user.uid;
      aliceRun = command: "su - ${user.name} -c 'XDG_RUNTIME_DIR=/run/user/${uid} ${command}'";
    in
    ''
      machine.wait_for_unit("multi-user.target")
      machine.succeed("loginctl enable-linger ${user.name}")
      machine.wait_for_unit("user@${uid}.service")
      machine.wait_for_unit("speech-dispatcher.socket", "${user.name}")

      machine.succeed("${aliceRun "spd-say 'hello'"}")
      machine.wait_until_succeeds("grep -q 'hello' /tmp/speechd-spoken.txt")
    '';
}
