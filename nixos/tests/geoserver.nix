{
  pkgs,
  lib,
  ...
}:
let
  geoserver = pkgs.geoserver;
  geoserverWithImporterExtension = pkgs.geoserver.withExtensions (ps: with ps; [ importer ]);

  # Blacklisted extensions:
  # - wps-jdbc needs a running (Postrgres) db server.
  blacklist = [ "wps-jdbc" ];

  blacklistedToNull = n: v: if !builtins.elem n blacklist then v else null;
  getNonBlackistedExtensionsAsList =
    ps: builtins.filter (x: x != null) (lib.attrsets.mapAttrsToList blacklistedToNull ps);
  geoserverWithAllExtensions = pkgs.geoserver.withExtensions (
    ps: getNonBlackistedExtensionsAsList ps
  );
in
{
  name = "geoserver";
  meta = {
    maintainers = with lib; [ teams.geospatial.members ];
  };

  nodes = {
    machine =
      { pkgs, ... }:
      {
        virtualisation.diskSize = 2 * 1024;

        environment.systemPackages = [
          geoserver
          geoserverWithAllExtensions
        ];

        services.geoserver = {
          enable = true;
          jettyOpts = "jetty.http.port=8090";
          package = geoserverWithImporterExtension;
        };
        systemd.services.geoserver.wantedBy = lib.mkForce [ ]; # do not start the service at boot
      };
  };

  testScript = ''
    from contextlib import contextmanager

    curl_cmd = "curl --fail --connect-timeout 2"
    curl_cmd_rest = f"{curl_cmd} -u admin:geoserver -X GET"
    base_url_pkg = "http://localhost:8080/geoserver"
    base_url_service = "http://localhost:8090/geoserver"
    log_file = "./log.txt"

    @contextmanager
    def running_geoserver_pkg(pkg):
      try:
        print(f"Launching geoserver from {pkg}...")
        machine.execute(f"{pkg}/bin/geoserver-startup > {log_file} 2>&1 &")
        machine.wait_until_succeeds(f"{curl_cmd} {base_url_pkg} 2>&1", timeout=60)
        yield
      finally:
        # We need to wait a little bit to make sure the server is properly
        # shutdown before launching a new instance.
        machine.execute(f"{pkg}/bin/geoserver-shutdown; sleep 1")

    @contextmanager
    def running_geoserver_service(service="geoserver"):
      try:
        print(f"Launching service {service}...")
        machine.execute(f"systemctl start {service} > tee {log_file} 2>&1")
        machine.wait_until_succeeds(f"{curl_cmd} {base_url_service} 2>&1", timeout=60)
        yield
      finally:
        # We need to wait a little bit to make sure the server is properly
        # shutdown before launching a new instance.
        machine.execute(f"systemctl stop {service}; sleep 1")

    start_all()

    with running_geoserver_pkg("${geoserver}"):
      machine.succeed(f"{curl_cmd} {base_url_pkg}/ows?service=WMS&version=1.3.0&request=GetCapabilities")

      # No extensions yet.
      machine.fail(f"{curl_cmd_rest} {base_url_pkg}/rest/imports")
      machine.fail(f"{curl_cmd_rest} {base_url_pkg}/rest/monitor/requests.csv")

    with running_geoserver_service():
      machine.succeed(f"{curl_cmd_rest} {base_url_service}/rest/imports")
      machine.fail(f"{curl_cmd_rest} {base_url_service}/rest/monitor/requests.csv")

    with running_geoserver_pkg("${geoserverWithAllExtensions}"):
      machine.succeed(f"{curl_cmd_rest} {base_url_pkg}/rest/imports")
      machine.succeed(f"{curl_cmd_rest} {base_url_pkg}/rest/monitor/requests.csv")
      _, stdout = machine.execute(f"cat {log_file}")
      print(stdout.replace("\\n", "\n"))
      assert "GDAL Native Library loaded" in stdout, "gdal"
      assert "The turbo jpeg encoder is available for usage" in stdout, "libjpeg-turbo"
      assert "org.geotools.imageio.netcdf.utilities.NetCDFUtilities" in stdout, "netcdf"
      assert "Unable to load library 'netcdf'" not in stdout, "netcdf"

  '';
}
