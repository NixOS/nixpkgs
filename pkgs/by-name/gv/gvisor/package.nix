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

  vendorHash = "sha256-RfumZ2XJ+68Y4oB27KpjAYhdFVmCnIUEYXBF7Yy/0IQ=";

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

  # The go.mod that gVisor publishes is not `go mod tidy`-clean: it still
  # carries requirements that are not imported by any built package (for
  # example the Bazel-only `github.com/bazelbuild/rules_go`), which makes
  # `go mod vendor` fail. Tidy the module in the fixed-output module
  # derivation, carry the result along in the vendor directory, and restore it
  # before the main build. Doing this at build time (instead of with a static
  # patch) keeps the package updateable by the update bot.
  overrideModAttrs = oldAttrs: {
    postPatch = (oldAttrs.postPatch or "") + ''
      export GOCACHE=$TMPDIR/go-cache
      export GOPATH=$TMPDIR/go
      go mod tidy
    '';
    postBuild = (oldAttrs.postBuild or "") + ''
      cp go.mod go.sum vendor/
    '';
  };

  preBuild = ''
    chmod -R u+w vendor
    cp vendor/go.mod vendor/go.sum .
  '';

  passthru = {
    tests = { inherit (nixosTests) gvisor; };
    updateScript = ./update.sh;
  };

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
