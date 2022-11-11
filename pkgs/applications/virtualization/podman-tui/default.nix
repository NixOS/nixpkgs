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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "podman-tui";
    rev = "v${version}";
    sha256 = "sha256-9ZFyrRf4yMik4+TQYN+75fWuKHuI8hkaKJ6o5qWYb7E=";
  };

  vendorSha256 = null;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gpgme libassuan ]
    ++ lib.optionals stdenv.isLinux [ btrfs-progs lvm2 ];

  ldflags = [ "-s" "-w" ];

  preCheck =
    let skippedTests = [
      "TestNetdialogs"
    ]; in
    ''
      export HOME=/home/$(whoami)

      # Disable flaky tests
      buildFlagsArray+=("-run" "[^(${builtins.concatStringsSep "|" skippedTests})]")
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
