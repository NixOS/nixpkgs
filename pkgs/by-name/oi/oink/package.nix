{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "oink";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "rlado";
    repo = "oink";
    rev = "v${version}";
    hash = "sha256-XbS4DPNPYfIEnATIG0u+7HPQmtX5rvl77j/3mdVB//8=";
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
