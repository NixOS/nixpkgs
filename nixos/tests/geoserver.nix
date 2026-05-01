{ pkgs, lib, ... }:

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
    maintainers = lib.teams.geospatial.members;
  };

  nodes = {
    machine =
      { pkgs, ... }:
      {
        virtualisation.diskSize = 2 * 1024;

        environment.systemPackages = [
          geoserver
          geoserverWithImporterExtension
          geoserverWithAllExtensions
        ];
      };
  };

  testScript = ''
    from contextlib import contextmanager

    curl_cmd = "curl --fail --connect-timeout 2"
    curl_cmd_rest = f"{curl_cmd} -u admin:geoserver -X GET"
    base_url = "http://localhost:8080/geoserver"
    log_file = "./log.txt"

    @contextmanager
    def running_geoserver(pkg):
      try:
        print(f"Launching geoserver from {pkg}...")
        machine.execute(f"{pkg}/bin/geoserver-startup > {log_file} 2>&1 &")
        machine.wait_until_succeeds(f"{curl_cmd} {base_url} 2>&1", timeout=60)
        yield
      finally:
        # We need to wait a little bit to make sure the server is properly
        # shutdown before launching a new instance.
        machine.execute(f"{pkg}/bin/geoserver-shutdown; sleep 1")

    start_all()

    with running_geoserver("${geoserver}"):
      machine.succeed(f"{curl_cmd} {base_url}/ows?service=WMS&version=1.3.0&request=GetCapabilities")

      # No extensions yet.
      machine.fail(f"{curl_cmd_rest} {base_url}/rest/imports")
      machine.fail(f"{curl_cmd_rest} {base_url}/rest/monitor/requests.csv")


    with running_geoserver("${geoserverWithImporterExtension}"):
      machine.succeed(f"{curl_cmd_rest} {base_url}/rest/imports")
      machine.fail(f"{curl_cmd_rest} {base_url}/rest/monitor/requests.csv")

    with running_geoserver("${geoserverWithAllExtensions}"):
      machine.succeed(f"{curl_cmd_rest} {base_url}/rest/imports")
      machine.succeed(f"{curl_cmd_rest} {base_url}/rest/monitor/requests.csv")
      _, stdout = machine.execute(f"cat {log_file}")
      print(stdout.replace("\\n", "\n"))
      assert "GDAL Native Library loaded" in stdout, "gdal"
      assert "The turbo jpeg encoder is available for usage" in stdout, "libjpeg-turbo"
      assert "org.geotools.imageio.netcdf.utilities.NetCDFUtilities" in stdout, "netcdf"
      assert "Unable to load library 'netcdf'" not in stdout, "netcdf"

  '';
}
