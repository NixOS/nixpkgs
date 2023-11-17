{ pkgs, lib, ... }: {

  name = "geoserver";
  meta = {
    maintainers = with lib; [ teams.geospatial.members ];
  };

  nodes = {
    machine = { pkgs, ... }: {
      virtualisation.diskSize = 2 * 1024;

      environment.systemPackages = [ pkgs.geoserver ];
    };
  };

  testScript = ''
    start_all()

    machine.execute("${pkgs.geoserver}/bin/geoserver-startup > /dev/null 2>&1 &")
    machine.wait_until_succeeds("curl --fail --connect-timeout 2 http://localhost:8080/geoserver", timeout=60)

    machine.succeed("curl --fail --connect-timeout 2 http://localhost:8080/geoserver/ows?service=WMS&version=1.3.0&request=GetCapabilities")
  '';
}
