{
  buildGoModule,
  version,
  src,
}:

buildGoModule rec {
  pname = "nekobox-core";
  inherit version src;

  sourceRoot = "${src.name}/nekoray/go/cmd/nekobox_core";

  vendorHash = "sha256-q/Co67AwJVElJnEY2O0SLLUzwlGiqazKu+fD/nnbrTk=";

  ldflags = [
    "-w"
    "-s"
    "-X github.com/matsuridayo/libneko/neko_common.Version_neko=${version}"
  ];

  tags = [
    "with_clash_api"
    "with_gvisor"
    "with_quic"
    "with_wireguard"
    "with_utls"
    "with_ech"
  ];
}
