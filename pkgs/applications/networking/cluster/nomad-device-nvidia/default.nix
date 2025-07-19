{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "nomad-device-nvidia";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad-device-nvidia";
    rev = "v${version}";
    sha256 = "sha256-jWhESp/LrNPhWbmSa5z3hZtqgcm9kStXEqP3Twssd7w=";
  };

  vendorHash = "sha256-WWgyuqxWJl87nTIAJI1F21rLO+tuzljokqQRrcj9ftc=";

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/hashicorp/nomad-device-nvidia";
    description = "Nomad device plugin for Nvidia GPUs";
    mainProgram = "nomad-device-nvidia";
    platforms = platforms.linux;
    license = licenses.mpl20;
    maintainers = with maintainers; [ samiser ];
  };
}
