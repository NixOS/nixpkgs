{ lib, fetchFromGitHub, buildGoPackage }:
buildGoPackage rec {
  pname = "terraform-provider-ansible";
  version = "1.0.3";

  goPackagePath = "github.com/nbering/terraform-provider-ansible";
  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "nbering";
    repo = "terraform-provider-ansible";
    rev = "v${version}";
    sha256 = "0dqi9ym0xvnz3h73cmd1vf6k2qwfhxvj1mcakkpmsd4cpxq4l6pr";
  };

  # Terraform allow checking the provider versions, but this breaks
  # if the versions are not provided via file paths.
  postBuild = "mv go/bin/terraform-provider-ansible{,_v${version}}";

  meta = with lib; {
    description = "A Terraform provider serving as an interop layer for an Ansible dynamic inventory script.";
    homepage = "https://github.com/nbering/terraform-provider-ansible";
    license = licenses.mpl20;
    maintainers = with maintainers; [ uskudnik ];
  };
}
