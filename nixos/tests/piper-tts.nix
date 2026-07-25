{
  ...
}:
{
  name = "piper-tts";

  nodes.machine =
    { config, pkgs, ... }:
    {
      virtualisation.memorySize = 3072;
      virtualisation.cores = 2;

      programs.piper-tts = {
        enable = true;
        voices = (
          v: with v; [
            en_US-amy-low
            zh_CN-xiao_ya-medium
          ]
        );
      };

      users.users.machine = {
        isNormalUser = true;
        linger = true;
        password = "machine";
      };
    };

  testScript = { nodes, ... }: ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    # Test local audio synthesize
    machine.succeed("command -v piper")

    machine.succeed(
        "local_english=$(mktemp) && "
        "time echo 'This is a test sentence.' | piper -m en_US-amy-low -f \"$local_english\" && "
        "size=$(stat -c%s \"$local_english\") && "
        "test \"$size\" -gt 44"
    )

    machine.succeed(
        "local_chinese=$(mktemp) && "
        "time echo '你好，世界。' | piper -m zh_CN-xiao_ya-medium -f \"$local_chinese\" && "
        "size=$(stat -c%s \"$local_chinese\") && "
        "test \"$size\" -gt 44"
    )
  '';
}
