{
  lib,
  buildGoModule,
  fetchFromGitHub,
  runCommand,
  cbtemulator,
  google-cloud-bigtable-tool,
}:

buildGoModule rec {
  pname = "cbtemulator";
  version = "1.29.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-go";
    rev = "bigtable/v${version}";
    hash = "sha256-prDwy65pxWDrIJOURe2JHo4sY4yP8IE1Rp1pLUL/IAA=";
  };

  # There's a go.{mod,sum} in the root and in the "bigtable" subdir.
  # We only ever use things in that subdir.
  sourceRoot = "${src.name}/bigtable";
  env.GOWORK = "off";

  vendorHash = "sha256-EDfxT56LKEu/iXPp5RJXb4UIRV2jFFNxh3ZINPbwKTM=";

  subPackages = [ "cmd/emulator" ];

  postInstall = ''
    mv $out/bin/emulator $out/bin/cbtemulator
  '';

  passthru = {
    # Sets up a table and family, then inserts, and ensures it gets back the value.
    tests.smoketest =
      runCommand "cbtemulator-smoketest"
        {
          nativeBuildInputs = [ google-cloud-bigtable-tool ];
        }
        ''
          # Start the emulator
          ${lib.getExe cbtemulator} &
          EMULATOR_PID=$!

          cleanup() {
            kill $EMULATOR_PID
          }

          trap cleanup EXIT

          export BIGTABLE_EMULATOR_HOST=localhost:9000

          cbt -instance instance-1 -project project-1 createtable table-1
          cbt -instance instance-1 -project project-1 createfamily table-1 cf1
          cbt -instance instance-1 -project project-1 ls table-1
          cbt -instance instance-1 -project project-1 set table-1 key1 cf1:c1=value1

          cbt -instance instance-1 -project project-1 read table-1 | grep -q value1

          touch $out;
        '';
  };

  meta = with lib; {
    description = "In-memory Google Cloud Bigtable server";
    homepage = "https://github.com/googleapis/google-cloud-go/blob/bigtable/v${version}/bigtable/cmd/emulator/cbtemulator.go";
    license = licenses.asl20;
    maintainers = [ maintainers.flokli ];
    mainProgram = "cbtemulator";
    platforms = platforms.all;
  };
}
