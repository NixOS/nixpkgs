{
  ...
}:
{
  name = "piper-tts";

  nodes.server =
    { config, pkgs, ... }:
    {
      virtualisation.memorySize = 3072;
      virtualisation.cores = 2;

      services.piper-tts = {
        enable = true;
        host = "0.0.0.0";
        port = 5000;
        openFirewall = true;
        defaultVoice = pkgs.piperTtsVoices.en_US-amy-low;
        voices = (
          v: with v; [
            en_US-amy-low
            zh_CN-xiao_ya-medium
          ]
        );
      };

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
  nodes.client =
    { config, pkgs, ... }:
    {

    };

  testScript = { nodes, ... }: ''
    server.start()
    server.wait_for_unit("multi-user.target")
    server.wait_for_unit("piper-tts.service", "machine")

    client.start()
    client.wait_for_unit("multi-user.target")

    # Test server audio synthesize
    # Warm up English
    print(client.succeed(
      "server_english=$(mktemp) && "
      "time curl -s -X POST -H 'Content-Type: application/json' "
      "-d '{ \"text\": \"This is a test sentence.\", \"voice\": \"en_US-amy-low\" }' "
      "server:${toString nodes.server.services.piper-tts.port}/synthesize -o \"$server_english\" && "
      "size=$(stat -c%s \"$server_english\") && "
      "test \"$size\" -gt 44"
    ))

    # Warm up Chinese
    print(client.succeed(
      "server_chinese=$(mktemp) && "
      "time curl -s -X POST -H 'Content-Type: application/json' "
      "-d '{ \"text\": \"你好，世界。\", \"voice\": \"zh_CN-xiao_ya-medium\" }' "
      "server:${toString nodes.server.services.piper-tts.port}/synthesize -o \"$server_chinese\" && "
      "size=$(stat -c%s \"$server_chinese\") && "
      "test \"$size\" -gt 44"
    ))

    # Test local audio synthesize
    server.succeed("command -v piper")

    server.succeed(
        "local_english=$(mktemp) && "
        "time echo 'This is a test sentence.' | piper -m en_US-amy-low -f \"$local_english\" && "
        "size=$(stat -c%s \"$local_english\") && "
        "test \"$size\" -gt 44"
    )

    server.succeed(
        "local_chinese=$(mktemp) && "
        "time echo '你好，世界。' | piper -m zh_CN-xiao_ya-medium -f \"$local_chinese\" && "
        "size=$(stat -c%s \"$local_chinese\") && "
        "test \"$size\" -gt 44"
    )
  '';
}
