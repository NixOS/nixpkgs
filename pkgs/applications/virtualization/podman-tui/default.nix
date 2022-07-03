{ lib
, stdenv
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
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-tui";
    rev = "v${version}";
    sha256 = "sha256-2WugN5JdTkz3OOt3ggzT7HwMXy1jxn85RwF7409D8m8=";
  };

  vendorSha256 = null;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gpgme libassuan ]
    ++ lib.optionals stdenv.isLinux [ btrfs-progs lvm2 ];

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
  };
}
