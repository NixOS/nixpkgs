{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nomad-driver-podman";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-miarvcV+b/6kbjHru7MpBIBU/v9ldHJGeXh2ATQ3BQ0=";
  };

  vendorSha256 = "sha256-AtgxHAkNzzjMQoSqROpuNoSDum/6JR+mLpcHLFL9EIY=";

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
