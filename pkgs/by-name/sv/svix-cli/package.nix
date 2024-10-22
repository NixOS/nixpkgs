{ lib, fetchFromGitHub, fetchpatch, buildGoModule }:

buildGoModule rec {
  version = "0.21.1";
  pname = "svix-cli";
  revision = "v${version}";

  src = fetchFromGitHub {
    owner = "svix";
    repo = pname;
    rev = revision;
    hash = "sha256-bHcxhJs4Nu/hdiftQFZMx4M5iqFtpOzrsvXOgo9NlDc=";
  };

  vendorHash = "sha256-qSzEpxktdAV+mHa+586mKvpclCpXR6sE7HNcPZywd4s=";

  # Increase minimum go version to 1.17 as the build fails with 1.16
  # due to modules requiring code that was introduced in 1.17
  # PR submitted upstream: https://github.com/svix/svix-cli/pull/103
  patches = [
    (fetchpatch {
      name = "increase-minimum-go.patch";
      url = "https://github.com/svix/svix-cli/commit/3c6fc06f72bd7e43165c31019b206ebad175d758.patch";
      hash = "sha256-OwiyBZ3IZGkvo6zEZY1+XYFrqT+RseqTJ5xwCl3LtVg=";
    })
  ];

  subPackages = [ "." ];

  ldflags =
    [ "-s" "-w" "-X github.com/svix/svix-cli/version.Version=v${version}" ];

  meta = with lib; {
    description = "A CLI for interacting with the Svix API";
    homepage = "https://github.com/svix/svix-cli/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ techknowlogick ];
  };
}
