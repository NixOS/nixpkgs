{ lib, buildGoModule, fetchFromSourcehut, installShellFiles, scdoc }:

buildGoModule rec {
  pname = "senpai";
  version = "0.2.0";

  src = fetchFromSourcehut {
    owner = "~taiite";
    repo = "senpai";
    rev = "v${version}";
    sha256 = "sha256-q167og8S8YbLcREZ7DVbJhjMzx4iO0WgIFkOV2IpieM=";
  };

  vendorSha256 = "sha256-PkoEHQEGKCiNbJsm7ieL65MtEult/wubLreJKA1gGpg=";

  subPackages = [
    "cmd/senpai"
  ];

  nativeBuildInputs = [
    scdoc
    installShellFiles
  ];

  postInstall = ''
    scdoc < doc/senpai.1.scd > doc/senpai.1
    scdoc < doc/senpai.5.scd > doc/senpai.5
    installManPage doc/senpai.*
  '';

  meta = with lib; {
    description = "Your everyday IRC student";
    homepage = "https://sr.ht/~taiite/senpai/";
    license = licenses.isc;
    maintainers = with maintainers; [ malte-v ];
  };
}
