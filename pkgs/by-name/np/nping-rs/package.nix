{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "nping-rs";
  version = "0.2.0-beta.2";

  src = fetchFromGitHub {
    owner = "hanshuaikang";
    repo = "Nping";
    rev = "refs/tags/v${version}";
    hash = "sha256-sXCADiwaKW1bi4lInRcMeOHDLo4ikLKk6ujATPL2OWU=";
  };

  cargoHash = "sha256-cUfEUK3VNvbd/JFsmY9mnhjLygHPTLn1CaBQe9F/X3U=";

  postInstall = ''
    # Avoid name clash
    mv $out/bin/nping $out/bin/nping-rs
  '';

  meta = {
    description = "Ping tool with real-time bata and visualizations";
    homepage = "https://github.com/hanshuaikang/Nping";
    changelog = "https://github.com/hanshuaikang/Nping/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "nping-rs";
  };
}
