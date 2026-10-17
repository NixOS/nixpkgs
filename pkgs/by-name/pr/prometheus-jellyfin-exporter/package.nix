{
  lib,
  fetchFromGitHub,
  buildGoModule,
  runCommand,
  nixosTests,
}:
let
  baseAttrs = rec {
    __structuredAttrs = true;

    pname = "prometheus-jellyfin-exporter";
    version = "1.4.0";

    src = fetchFromGitHub {
      owner = "rebelcore";
      repo = "jellyfin_exporter";
      rev = "v${version}";
      sha256 = "0pghbfqgapwx2zxf1pszryn3qwiwyqp744q0dskgix4r58l4d6f2";
    };

    vendorHash = "sha256-e08u10e/wNapNZSsD/fGVN9ybMHe3sW0yDIOqI8ZcYs=";
    meta = {
      description = "Prometheus exporter for Jellyfin";
      homepage = "https://github.com/rebelcore/jellyfin_exporter";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ zaz ];
      mainProgram = "jellyfin_exporter";
    };
  };
  testpkg = buildGoModule (baseAttrs // { buildTestBinaries = true; });
in
buildGoModule (
  baseAttrs
  // {
    # as of v1.4.0, upstream go tests don't work in the nix build sandbox, as they are actually
    # integration tests that spawn the binary and use the network.
    # instead of running them directly, we build them separately and run them here
    # TODO revisit on next release if i manage to contribute more compliant upstream tests
    doCheck = false;
    passthru.tests = {
      inherit (nixosTests.prometheus-exporters) jellyfin;
      gotests =
        runCommand "${baseAttrs.pname}-test"
          {
            nativeBuildInputs = [
              testpkg
            ];
          }
          ''
            jellyfin_exporter.test > $out
            [ "$(cat $out)" = "PASS" ] || { echo "tests failed to pass" && cat $out && exit 1; };
          '';
    };
  }
)
