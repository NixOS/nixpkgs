{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sesh";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "joshmedeski";
    repo = "sesh";
    rev = "v${version}";
    sha256 = "sha256-m/EcWh4wfna9PB/NN+MCRUsz5Er0OZ70AAumlKdrm/s=";
  };

  vendorHash = "sha256-zt1/gE4bVj+3yr9n0kT2FMYMEmiooy3k1lQ77rN6sTk=";

  meta = with lib; {
    description = "Smart session manager for the terminal.";
    homepage = "https://github.com/joshmedeski/sesh";
    license = licenses.mit;
    maintainers = with maintainers; [ Meliketoaste ];
    mainProgram = "sesh";
  };
}
