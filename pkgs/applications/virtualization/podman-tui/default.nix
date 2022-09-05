{ lib
, stdenv
, pkg-config
, fetchFromGitHub
, fetchpatch
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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-tui";
    rev = "v${version}";
    sha256 = "sha256-XLC1DqOME9xMF4z+cOPe5H60JnxU9gGaSOQQIofdtj8=";
  };

  patches = [
    # Fix flaky tests. See https://github.com/containers/podman-tui/pull/129.
    (fetchpatch {
      url = "https://github.com/containers/podman-tui/commit/7fff27e95a3891163da79d86bbc796f29b523f80.patch";
      sha256 = "sha256-mETDXoMLq7vb8Qhpz/CmNG1LmY2DTaogI10Qav/qN9Q=";
    })
  ];

  vendorSha256 = null;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gpgme libassuan ]
    ++ lib.optionals stdenv.isLinux [ btrfs-progs lvm2 ];

  ldflags = [ "-s" "-w" ];

  preCheck = ''
    export HOME=/home/$(whoami)
  '';

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
