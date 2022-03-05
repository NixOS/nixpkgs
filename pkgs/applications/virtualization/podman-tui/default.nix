{ lib
, pkg-config
, fetchFromGitHub
, buildGoModule
, btrfs-progs
, gpgme
, lvm2
}:
buildGoModule rec {
  pname = "podman-tui";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-tui";
    rev = "v${version}";
    sha256 = "sha256-qPQSu6l1WkX6sddVr5h1DqKQCyw6vy8S6lXC/ZO4DL8=";
  };

  vendorSha256 = null;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    btrfs-progs
    gpgme
    lvm2
  ];

  ldflags = [ "-s" "-w" ];

  subPackages = [ "." ];

  meta = with lib; {
    homepage = "https://github.com/containers/podman-tui";
    description = "Podman Terminal UI";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    platforms = platforms.linux;
  };
}
