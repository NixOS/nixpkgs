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
  version = "20231113.0";

  # gvisor provides a synthetic go branch (https://github.com/google/gvisor/tree/go)
  # that can be used to build gvisor without bazel.
  # For updates, you should stick to the commits labeled "Merge release-** (automated)"

  src = fetchFromGitHub {
    owner = "google";
    repo = "gvisor";
    rev = "cdaf5c462c4040ed4cc88989e43f7d373acb9d24";
    hash = "sha256-9d2AJXoGFRCSM6900gOBxNBgL6nxXqz/pPan5EeEdsI=";
  };

  vendorHash = "sha256-QdsVELNcIVsZv2gA05YgQfMZ6hmnfN2GGqW6r+mHqbs=";

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
