{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nomad-driver-podman";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MYqsTuMLxbVNWLAWjQ8xQts5qJvhTylle7YLtGyswjY=";
  };

  vendorHash = "sha256-wjJ+mq/m7IjbwypoBvBhjOyAT4v4HDSChHY5OE0xA2U=";

  subPackages = [ "." ];

  # some tests require a running podman service
  doCheck = false;

  meta = with lib; {
    homepage = "https://www.github.com/hashicorp/nomad-driver-podman";
    description = "Podman task driver for Nomad";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}
