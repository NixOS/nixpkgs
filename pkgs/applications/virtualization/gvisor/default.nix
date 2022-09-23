{ lib
, buildGoModule
, fetchFromGitHub
, iproute2
, iptables
, makeWrapper
, procps
}:

buildGoModule rec {
  pname = "gvisor";
  version = "20220919.0";

  # gvisor provides a synthetic go branch (https://github.com/google/gvisor/tree/go)
  # that can be used to build gvisor without bazel.
  # For updates, you should stick to the commits labeled "Merge release-** (automated)"

  src = fetchFromGitHub {
    owner = "google";
    repo = "gvisor";
    rev = "4e7fd140e8d0056f8f031950fcace8ff4d48a526";
    sha256 = "sha256-II0lnthabkyCgPum7EBdyOYwB0rWjA2Jd9DVGLJQy6Q=";
  };

  vendorSha256 = "sha256-iGLWxx/Kn1QaJTNOZcc+mwoF3ecEDOkaqmA0DH4pdgU=";

  nativeBuildInputs = [ makeWrapper ];

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  subPackages = [ "runsc" "shim" ];

  postInstall = ''
    # Needed for the 'runsc do' subcomand
    wrapProgram $out/bin/runsc \
      --prefix PATH : ${lib.makeBinPath [ iproute2 iptables procps ]}
    mv $out/bin/shim $out/bin/containerd-shim-runsc-v1
  '';

  meta = with lib; {
    description = "Application Kernel for Containers";
    homepage = "https://github.com/google/gvisor";
    license = licenses.asl20;
    maintainers = with maintainers; [ andrew-d gpl ];
    platforms = [ "x86_64-linux" ];
  };
}
