{ lib
, nixosTests
, buildGoModule
, fetchFromGitHub
, iproute2
, iptables
, makeWrapper
, procps
}:

buildGoModule {
  pname = "gvisor";
  version = "20240311.0-unstable-2024-03-25";

  # gvisor provides a synthetic go branch (https://github.com/google/gvisor/tree/go)
  # that can be used to build gvisor without bazel.
  # For updates, you should stick to the commits labeled "Merge release-** (automated)"

  src = fetchFromGitHub {
    owner = "google";
    repo = "gvisor";
    rev = "b1e227737fd6e3bb3b11a403a1a5013bc89b3b60";
    hash = "sha256-EfXzXkoEgtEerNMacRhbITCRig+t23WlIRya0BlJZcE=";
  };

  vendorHash = "sha256-jbMXeNXzvjfJcIfHjvf8I3ePjm6KFTXJ94ia4T2hUs4=";

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  subPackages = [ "runsc" "shim" ];

  postInstall = ''
    # Needed for the 'runsc do' subcommand
    wrapProgram $out/bin/runsc \
      --prefix PATH : ${lib.makeBinPath [ iproute2 iptables procps ]}
    mv $out/bin/shim $out/bin/containerd-shim-runsc-v1
  '';

  passthru.tests = { inherit (nixosTests) gvisor; };

  meta = with lib; {
    description = "Application Kernel for Containers";
    homepage = "https://github.com/google/gvisor";
    license = licenses.asl20;
    maintainers = with maintainers; [ andrew-d gpl ];
    platforms = [ "x86_64-linux" ];
  };
}
