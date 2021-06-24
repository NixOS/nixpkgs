{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terraform-provider-lxd";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "sl1pm4t";
    repo = "terraform-provider-lxd";
    rev = "v${version}";
    sha256 = "sha256-ikI8LQ6qawdeUSb1Ee03H409DQw2M4QtsIxAESxXNRI=";
  };

  vendorSha256 = "sha256-IjpC7bFodqdrqVUEQdZBc6N8py5+t2kRYvcQiPr7CHc=";

  doCheck = false;

  postBuild = "mv ../go/bin/terraform-provider-lxd{,_v${version}}";

  meta = with lib; {
    homepage = "https://github.com/sl1pm4t/terraform-provider-lxd";
    description = "Terraform provider for lxd";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ gila ];
  };
}
