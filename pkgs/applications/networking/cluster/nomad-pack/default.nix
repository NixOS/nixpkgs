{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "nomad-pack";
  version = "2022-04-12";
  rev   = "50ad747d2a5a2b90af1b3564483510cb04fefbea";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    inherit rev;
    sha256 = "sha256-VG6Dmx5WD2AzKReMbmrpzXCNhrJqaZY3aQV9P+4ET68=";
  };

  vendorSha256 = "sha256-7ovR2F9N94iFK/B5OXRcqfykOYHST3354+Ge2L8yzq0=";

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
