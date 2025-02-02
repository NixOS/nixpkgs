{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nomad-driver-podman";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aD5Sh2/4juHzeB64Sl0Zpioq9TLIA9PUOf6Gk98W+Js=";
  };

  vendorHash = "sha256-ILfH2QXQIM/ybSAXqmRYe99HmgZ18wuCHQUrZf1GS2Y=";

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
