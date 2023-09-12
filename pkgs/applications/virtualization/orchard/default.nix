{lib, buildGoModule, fetchFromGitHub, tart}:
buildGoModule rec {
  pname = "orchard";
  version = "0.11.0";
  src = fetchFromGitHub {
    owner = "cirruslabs";
    repo = pname;
    rev = version;
    sha256 = "sha256-DRaolnvHpijnC1LuQlJCG3xj7cU6YJsbCxYrB22E82U=";
  };
  vendorHash = "sha256-BrzS+QtpGUHcYNNmSI6FlBtcYwNFri7R6nlVvFihdb4=";

  nativeCheckInputs = [ tart ];
  # This has a ton of failures I cannot explain.
  doCheck = false;

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Orchestrator for running Tart Virtual Machines on a cluster of Apple Silicon devices.";
    license     = licenses.fairsource09;
    maintainers = with maintainers; [ roblabla ];
    platforms   = platforms.unix;
  };
}
