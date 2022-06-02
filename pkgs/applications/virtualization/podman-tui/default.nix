{ lib
, pkg-config
, fetchFromGitHub
, buildGoModule
, btrfs-progs
, gpgme
, libassuan
, lvm2
, testers
, podman-tui
}:
buildGoModule rec {
  pname = "podman-tui";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-tui";
    rev = "v${version}";
    sha256 = "sha256-Xc6F87evQiv4jRbxxRBzJBeI8653HvlQL+UwcVWY0wk=";
  };

  vendorSha256 = null;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    btrfs-progs
    gpgme
    libassuan
    lvm2
  ];

  ldflags = [ "-s" "-w" ];

  passthru.tests.version = testers.testVersion {
    package = podman-tui;
    command = "podman-tui version";
    version = "v${version}";
  };

  meta = with lib; {
    homepage = "https://github.com/containers/podman-tui";
    description = "Podman Terminal UI";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    platforms = platforms.linux;
  };
}
