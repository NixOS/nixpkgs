{ lib, pkgs, ... }:
let
  # Bifrost fetches its pricing datasheets at startup and exits when that fails
  # with nothing cached. The test VM has no network, so serve empty ones locally.
  pricingPort = 18765;
  pricing = pkgs.runCommand "bifrost-pricing" { } ''
    mkdir -p $out
    echo '{}' > $out/datasheet
    echo '{}' > $out/model-parameters
  '';
in
{
  name = "bifrost";
  meta.maintainers = with lib.maintainers; [ ManUtopiK ];

  nodes.machine = {
    services.bifrost = {
      enable = true;
      settings.framework.pricing = {
        pricing_url = "http://127.0.0.1:${toString pricingPort}/datasheet";
        model_parameters_url = "http://127.0.0.1:${toString pricingPort}/model-parameters";
      };
    };

    systemd.services.bifrost-pricing = {
      wantedBy = [ "multi-user.target" ];
      before = [ "bifrost.service" ];
      serviceConfig.ExecStart = "${lib.getExe pkgs.python3} -m http.server ${toString pricingPort} --bind 127.0.0.1 --directory ${pricing}";
    };
  };

  testScript = ''
    from datetime import timedelta

    machine.wait_for_unit("bifrost.service")
    machine.wait_for_open_port(8080)

    with subtest("serves the admin UI"):
        machine.succeed("curl -sSf http://127.0.0.1:8080/ | grep -i '<html'")

    with subtest("serves the OpenAI-compatible API"):
        machine.succeed("curl -sSf http://127.0.0.1:8080/v1/models")

    with subtest("stays up past the pricing sync"):
        machine.sleep(duration=timedelta(seconds=15))
        machine.require_unit_state("bifrost.service", "active")
  '';
}
