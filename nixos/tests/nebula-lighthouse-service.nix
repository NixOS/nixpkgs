{ pkgs, lib, ... }:
{
  name = "nebula-lighthouse-service";

  meta.maintainers = with lib.maintainers; [
    bloominstrong
  ];

  nodes.machine =
    { ... }:
    {
      environment.systemPackages = with pkgs; [
        nebula
      ];
      services.nebula-lighthouse-service.enable = true;

    };

  testScript = ''
    start_all()
    machine.succeed(
      'nebula-cert ca -duration $((10*365*24*60))m -name "NLS Test" -out-crt ca.crt -out-key ca.key',
      'nebula-cert sign -duration $((365*24*60))m -ca-crt ca.crt -ca-key ca.key -name "lighthouse" -groups "lighthouse" -ip "10.0.100.1/24" -out-crt lighthouse.crt -out-key lighthouse.key'
    )
    machine.wait_for_unit("nebula-lighthouse-service.service")
    machine.wait_for_open_port(8080)
    machine.succeed(
      'curl -X POST "http://127.0.0.1:8080/lighthouse/" -F ca_crt=@./ca.crt -F host_crt=@./lighthouse.crt -F host_key=@./lighthouse.key',
      'curl -X GET "http://127.0.0.1:8080/lighthouse/" -F ca_crt=@./ca.crt -F host_crt=@./lighthouse.crt -F host_key=@./lighthouse.key',
      'pgrep -x nebula'
    )
  '';
}
