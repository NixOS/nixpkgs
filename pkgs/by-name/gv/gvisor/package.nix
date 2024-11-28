{ lib
, nixosTests
, buildGoModule
, fetchFromGitHub
, iproute2
, iptables
, makeWrapper
, procps
, glibc
}:

buildGoModule {
  pname = "gvisor";
  version = "20240401.0";

  # gvisor provides a synthetic go branch (https://github.com/google/gvisor/tree/go)
  # that can be used to build gvisor without bazel.
  # For updates, you should stick to the commits labeled "Merge release-** (automated)"

  src = fetchFromGitHub {
    owner = "google";
    repo = "gvisor";
    rev = "9d995324d058812a5476f8c06b20167012511e9c";
    hash = "sha256-idgUEbYAfnm/HphVs12Sj1FwG+jmL2BBr0PJnG9BC3A=";
  };

    # Replace the placeholder with the actual path to ldconfig
  postPatch = ''
    substituteInPlace runsc/container/container.go \
      --replace-fail '"/sbin/ldconfig"' '"${glibc}/bin/ldconfig"'
  '';

  vendorHash = "sha256-jbMXeNXzvjfJcIfHjvf8I3ePjm6KFTXJ94ia4T2hUs4=";

  nativeBuildInputs = [ makeWrapper ];

  env.CGO_ENABLED = 0;

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
    maintainers = with maintainers; [ gpl ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
