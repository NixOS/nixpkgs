{ lib, rustPlatform, fetchCrate }:

rustPlatform.buildRustPackage rec {
  pname = "preserves-tools";
  version = "4.992.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-1IX6jTAH6qWE8X7YtIka5Z4y70obiVotOXzRnu+Z6a0=";
  };

  cargoHash = "sha256-D/ZCKRqZtPoCJ9t+5+q1Zm79z3K6Rew4eyuyDiGVGUs=";

  meta = {
    description =
      "Command-line utilities for working with Preserves documents";
    homepage = "https://preserves.dev/doc/preserves-tool.html";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "preserves-tool";
  };
}
