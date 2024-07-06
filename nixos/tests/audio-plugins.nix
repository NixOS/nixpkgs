import ./make-test-python.nix ({ lib, ... }:
{
  name = "audio-plugins";

  nodes.machine = { config, pkgs, ... }: with pkgs; {
    environment.systemPackages = [ ladspa-sdk lilv ];
    services.audio-plugins.ladspa-plugins = [
      rnnoise-plugin
      ladspa-sdk
    ];
    services.audio-plugins.lv2-plugins = [
      rnnoise-plugin
      swh_lv2
    ];
  };

  testScript = ''
    machine.succeed("listplugins | grep 'Noise Suppressor for Voice (Mono)'")
    machine.succeed("listplugins | grep 'Simple Delay Line (1043/delay_5s)'")
    machine.succeed("[ $(lv2ls | wc -l) -ne 0 ]")
  '';
})
