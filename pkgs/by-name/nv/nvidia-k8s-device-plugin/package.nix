{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nvidiaPackages ? null,
}:

buildGoModule rec {
  pname = "nvidia-k8s-device-plugin";
  version = "0.18.0";
  # version = "0.14.3";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "k8s-device-plugin";
    rev = "v${version}";
    sha256 = "sha256-caZCbEvOQ1jHJua15qVMLrAVUOAxSou7mgvavDIeSNE=";
    # sha256 = "sha256-rN4SIX77EiXEe2LVoGYOIe4RkyPgo4TLtKuG8tC7NQk=";
  };

  vendorHash = null;

  buildInputs = lib.optional (nvidiaPackages != null) (with nvidiaPackages; [ production ]);

  ldflags = [
    "-s"
    "-w"
  ]
  ++ lib.optional (nvidiaPackages != null) [
    # lazy because unresolved nvmlDeviceCcuSetStreamState, which isn't used
    # anyway, but I can't figure out to link it properly for the loader to find
    # early
    "-extldflags '-Wl,-z,lazy -lnvidia-ml -lcuda'"
  ];

  subPackages = [ "cmd/nvidia-device-plugin" ];

  # Make it possible to build on machines without nivida hw
  makeFlags = lib.optional (nvidiaPackages != null) [
    "LDFLAGS=-L${nvidiaPackages.production}/lib"
    "CFLAGS=-I${nvidiaPackages.production}/include"
  ];

  # # github.com/cilium/ebpf/internal/unix
  # vendor/github.com/cilium/ebpf/internal/unix/types_linux.go:40:36: undefined: linux.BPF_F_KPROBE_MULTI_RETURN
  # FAIL    github.com/NVIDIA/k8s-device-plugin/tests/e2e [build failed]
  doCheck = false;

  meta = with lib; {
    description = "NVIDIA device plugin for Kubernetes";
    homepage = "https://github.com/NVIDIA/k8s-device-plugin";
    license = licenses.unfree; # Nividia stuff
    maintainers = [ ];
    mainProgram = "nvidia-device-plugin";
    platforms = platforms.linux;
  };
}
