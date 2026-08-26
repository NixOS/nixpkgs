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

        # The VM has several Geoserver package installations. They can't be run
        # in parallel but are launched sequentially during the test run.
        # Context managers (see below) are used to start/stop them selectively.
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

    CURL_CMD = "curl --fail --connect-timeout 2"
    CURL_CMD_REST = f"{CURL_CMD} -u admin:geoserver -X GET"
    BASE_URL_PKG = "http://localhost:8080/geoserver"
    BASE_URL_SERVICE = "http://localhost:8090/geoserver"
    log_file = "./log.txt"

    @contextmanager
    def running_geoserver_pkg(pkg):
      try:
        print(f"Launching geoserver from {pkg}...")
        machine.execute(f"{pkg}/bin/geoserver-startup > {log_file} 2>&1 &")
        machine.wait_until_succeeds(f"{CURL_CMD} {BASE_URL_PKG} 2>&1", timeout=60)
        yield
      finally:
        # We need to wait a little bit to make sure the server is properly
        # shutdown before launching a new instance.
        machine.execute(f"{pkg}/bin/geoserver-shutdown; sleep 1")

    @contextmanager
    def running_geoserver_service():
      service_name = "geoserver"
      try:
        print(f"Launching service {service_name}...")
        machine.execute(f"systemctl start {service_name} > tee {log_file} 2>&1")
        machine.wait_until_succeeds(f"{CURL_CMD} {BASE_URL_SERVICE} 2>&1", timeout=60)
        yield
      finally:
        # We need to wait a little bit to make sure the server is properly
        # shutdown before launching a new instance.
        machine.execute(f"systemctl stop {service_name}; sleep 1")

    start_all()

    with subtest("A standalone Geoserver installation without extensions can be started."):
      with running_geoserver_pkg("${geoserver}"):
        machine.succeed(f"{CURL_CMD} {BASE_URL_PKG}/ows?service=WMS&version=1.3.0&request=GetCapabilities")

        # No extensions yet.
        machine.fail(f"{CURL_CMD_REST} {BASE_URL_PKG}/rest/imports")
        machine.fail(f"{CURL_CMD_REST} {BASE_URL_PKG}/rest/monitor/requests.csv")

    with subtest("A standalone Geoserver installation with numerous extensions can be started."):
      with running_geoserver_pkg("${geoserverWithAllExtensions}"):
        machine.succeed(f"{CURL_CMD_REST} {BASE_URL_PKG}/rest/imports")
        machine.succeed(f"{CURL_CMD_REST} {BASE_URL_PKG}/rest/monitor/requests.csv")
        _, stdout = machine.execute(f"cat {log_file}")
        print(stdout.replace("\\n", "\n"))
        assert "GDAL Native Library loaded" in stdout, "gdal"
        assert "org.geotools.imageio.netcdf.utilities.NetCDFUtilities" in stdout, "netcdf"
        assert "Unable to load library 'netcdf'" not in stdout, "netcdf"

        # libjpeg-turbo is disabled as of 2.28.1.
        # assert "The turbo jpeg encoder is available for usage" in stdout, "libjpeg-turbo"

    with subtest("Geoserver can be run as a service. Some Extensions are available."):
      with running_geoserver_service():
        # Only the importer extension is available.
        machine.succeed(f"{CURL_CMD_REST} {BASE_URL_SERVICE}/rest/imports")
        machine.fail(f"{CURL_CMD_REST} {BASE_URL_SERVICE}/rest/monitor/requests.csv")


  '';
}
