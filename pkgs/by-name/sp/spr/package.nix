{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "spr";
  version = "1.3.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-lsdWInJWcofwU3P4vAWcLQeZuV3Xn1z30B7mhODJ4Vc=";
  };

  cargoHash = "sha256-4fYQM+GQ5yqES8HQ23ft4wfM5mwDdcWuE5Ed2LST9Gw=";

  meta = with lib; {
    description = "Submit pull requests for individual, amendable, rebaseable commits to GitHub";
    mainProgram = "spr";
    homepage = "https://github.com/spacedentist/spr";
    license = licenses.mit;
    maintainers = with maintainers; [ spacedentist ];
  };
}
