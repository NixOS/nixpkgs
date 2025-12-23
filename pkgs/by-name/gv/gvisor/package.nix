{
  lib,
  nixosTests,
  buildGoModule,
  fetchFromGitHub,
  iproute2,
  iptables,
  makeWrapper,
  procps,
  glibc,
}:

buildGoModule {
  pname = "gvisor";
  version = "20251110.0";

  # gvisor provides a synthetic go branch (https://github.com/google/gvisor/tree/go)
  # that can be used to build gvisor without bazel.
  # For updates, you should stick to the commits labeled "Merge release-** (automated)"

  src = fetchFromGitHub {
    owner = "google";
    repo = "gvisor";
    rev = "2617196c08506a30764bf6261b79d52797916dda";
    hash = "sha256-qx1uCRTJVotSbTojBf/Nj8LfLdUvsnxMkPuyJjLLadM=";
  };

  # Replace the placeholder with the actual path to ldconfig
  postPatch = ''
    substituteInPlace runsc/container/container.go \
      --replace-fail '"/sbin/ldconfig"' '"${glibc}/bin/ldconfig"'
  '';

  vendorHash = "sha256-Ey4M3NK/+AVkr7r0aA+kAfNk1yVfnDn3Izy7u74HFkE=";

  nativeBuildInputs = [ makeWrapper ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  subPackages = [
    "runsc"
    "shim"
  ];

  postInstall = ''
    # Needed for the 'runsc do' subcommand
    wrapProgram $out/bin/runsc \
      --prefix PATH : ${
        lib.makeBinPath [
          iproute2
          iptables
          procps
        ]
      }
    mv $out/bin/shim $out/bin/containerd-shim-runsc-v1
  '';

  passthru.tests = { inherit (nixosTests) gvisor; };

  meta = {
    description = "Application Kernel for Containers";
    homepage = "https://github.com/google/gvisor";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ gpl ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
