{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:

buildGoModule rec {
  name = "netobserv-ebpf-agent";

  src = fetchFromGitHub {
    owner = "netobserv";
    repo = name;
    tag = "v1.7.0-community";
    hash = "sha256-6FErDakmEXHgIiGvZTOi2Mv2MTagD4ZNTUr2GvVrNPc=";
  };

  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/${name}
  '';

  meta = {
    description = "Network Observability eBPF Agent";
    homepage = "https://github.com/netobserv/netobserv-ebpf-agent";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fooker ];
  };
}
