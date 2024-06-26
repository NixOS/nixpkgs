{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "oink";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "rlado";
    repo = "oink";
    rev = "v${version}";
    hash = "sha256-ojvuA5IlayPMNajl2+a4lx8NU06Da0vp9TJHCQVMtlo=";
  };

  vendorHash = null;

  postInstall = ''
    mv $out/bin/src $out/bin/oink
  '';

  meta = {
    description = "Dynamic DNS client for Porkbun";
    homepage = "https://github.com/rlado/oink";
    license = lib.licenses.mit;
    mainProgram = "oink";
    maintainers = with lib.maintainers; [ jtbx ];
  };
}
