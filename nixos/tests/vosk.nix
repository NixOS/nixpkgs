import ./make-test-python.nix ({ lib, pkgs, ... }: {
  name = "vosk";

  nodes.machine = {
    services.vosk = {
      enable = true;
      # The test does not use one of the packaged models for two reasons:
      #  - The large models require 8GiB+ RAM and ideally multiple CPU cores
      #  - An update to the model could make the test assertion fail
      model = pkgs.fetchzip {
        url = "https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip";
        sha256 = "sha256-CIoPZ/krX+UW2w7c84W3oc1n4zc9BBS/fc8rVYUthuY=";
        meta.license = lib.licenses.asl20;
      };
    };
  };

  testScript = { nodes, ... }: ''
    machine.wait_for_open_port(2700)

    machine.succeed("${pkgs.python3.withPackages (ps: [ ps.websockets ])}/bin/python ${pkgs.vosk-server.src}/websocket/test.py ${pkgs.vosk-server.src}/websocket/test16k.wav | ${pkgs.jq}/bin/jq -r 'select(.text).text' > /tmp/result")
    machine.succeed("grep 'one zero zero zero one' /tmp/result")
    machine.succeed("grep 'nah no to i know' /tmp/result")
    machine.succeed("grep 'zero one eight zero three' /tmp/result")
  '';
})
