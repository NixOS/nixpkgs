{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nomad-driver-podman";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QvIc0RNQX9do6pTyGbJTTR7jANp50DVlHsl/8teiCnY=";
  };

  vendorHash = "sha256-9uXpcF/b2iR3xwVQ6XwJ9USuVqzYND4nuGMjMmEIbVs=";

  subPackages = [ "." ];

  # some tests require a running podman service
  doCheck = false;

  meta = with lib; {
    homepage = "https://www.github.com/hashicorp/nomad-driver-podman";
    description = "Podman task driver for Nomad";
    mainProgram = "nomad-driver-podman";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}
