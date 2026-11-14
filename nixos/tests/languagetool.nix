{ lib, ... }:
let
  port = 8082;
  apiCheck = "http://localhost:${toString port}/v2/check";
in
{
  name = "languagetool";
  meta.maintainers = [ lib.maintainers.fbeffa ];

  containers.machine.services.languagetool = {
    enable = true;
    inherit port;
    n-grams = {
      de.enable = true;
      en.enable = true;
      es.enable = true;
      fr.enable = true;
      nl.enable = true;
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("languagetool.service")
    machine.wait_for_open_port(${toString port})
    machine.wait_until_succeeds('curl -d "language=en-US" -d "text=a simple test" ${apiCheck}')

    with subtest("n-grams are enabled"):
      import json
      response = machine.succeed('curl -d "language=en-US" -d "text=Don’t forget to put on the breaks." ${apiCheck}')
      data = json.loads(response)
      t.assertEqual(data["matches"][0]["rule"]["id"], "CONFUSION_RULE_BREAKS_BRAKES")
      response = machine.succeed('curl -d "language=de-DE" -d "text=In den christlichen Traditionen gibt es unterschiedliche Anleitungen zur Mediation und Kontemplation." ${apiCheck}')
      data = json.loads(response)
      t.assertEqual(data["matches"][0]["rule"]["id"], "CONFUSION_RULE_MEDIATION_MEDITATION")
  '';
}
