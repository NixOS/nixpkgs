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
  version = "20260406.0";

  # gvisor provides a synthetic go branch (https://github.com/google/gvisor/tree/go)
  # that can be used to build gvisor without bazel.
  # For updates, you should stick to the commits labeled "Merge release-** (automated)"

  src = fetchFromGitHub {
    owner = "google";
    repo = "gvisor";
    rev = "db8d2c9abca39156c61ee2769d52b8a11accbe16";
    hash = "sha256-T0ilLqZTX2KNZdR7wuMnYimnL+G5Tbkd77IULCZE764=";
  };

  # Replace the placeholder with the actual path to ldconfig
  postPatch = ''
    substituteInPlace runsc/container/container.go \
      --replace-fail '"/sbin/ldconfig"' '"${glibc}/bin/ldconfig"'
  '';

  vendorHash = "sha256-8Zkgt5hegYEHnG1lF+wLgdru6t3l+Z/qKRvJHukZbPo=";

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

  patches = [ ./fix-go-mod-tidy.diff ];

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
