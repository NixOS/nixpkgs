{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "nomad-pack";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5OTGBO2EMGPJ4J2Eu3pIlZmYGXYxgL/6uGQgdB+8nPk=";
  };

  vendorHash = "sha256-8hWiVtya/TlVLUlYVJSjOzZUI8vsPm355ksIRPhB2rA=";

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
    description = "Nomad Pack is a templating and packaging tool used with HashiCorp Nomad";
    license = licenses.mpl20;
    maintainers = with maintainers; [ techknowlogick ];
  };

}
