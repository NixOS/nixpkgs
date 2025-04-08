{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:

buildGoModule rec {
  pname = "helmsman";
  version = "3.18.0";

  src = fetchFromGitHub {
    owner = "Praqma";
    repo = "helmsman";
    rev = "v${version}";
    sha256 = "sha256-k/rgQttCA4Ahip9zV+z9zbVSy8NKUTIR4/pluqpP/1c=";
  };

  subPackages = [ "cmd/helmsman" ];

  vendorHash = "sha256-lIBtKwxdmUIRYifEhrjzHilEsgLIf4Mtq/pa7N/E+NM=";

  doCheck = false;

  meta = with lib; {
    description = "Helm Charts (k8s applications) as Code tool";
    mainProgram = "helmsman";
    homepage = "https://github.com/Praqma/helmsman";
    license = licenses.mit;
    maintainers = with maintainers; [
      lynty
      sarcasticadmin
    ];
  };
}
