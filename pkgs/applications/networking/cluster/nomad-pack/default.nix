{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "nomad-pack";
  version = "2022-02-11";
  rev   = "568ac5e42bc41172a1fa3c8b18af2f42b9e341ff";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    inherit rev;
    sha256 = "sha256-0hvnGdUT72sWvMER67ZBxcC+VTbuFMIos2NudOjeTB8=";
  };

  vendorSha256 = "sha256-wmoXZIogKj4i9+AsEjY7QaT2Tn4LQyGQcEFHrRO0W9s=";

  # skip running go tests as they require network access
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/nomad-pack --version
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/hashicorp/nomad-pack";
    changelog = "https://github.com/hashicorp/nomad-pack/blob/main/CHANGELOG.md";
    description = "Nomad Pack is a templating and packaging tool used with HashiCorp Nomad.";
    license = licenses.mpl20;
    maintainers = with maintainers; [ techknowlogick ];
  };

}
