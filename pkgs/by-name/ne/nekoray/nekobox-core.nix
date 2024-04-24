{
  buildGoModule,
  version,
  src,
  extraSources,
}:

buildGoModule rec {
  pname = "nekobox-core";
  inherit version src;
  sourceRoot = "${src.name}/go/cmd/nekobox_core";

  postPatch = ''
    cp -r --no-preserve=all ${extraSources.libneko} ../../../../libneko
    cp -r --no-preserve=all ${extraSources.sing-box-extra} ../../../../sing-box-extra
    cp -r --no-preserve=all ${extraSources.sing-box} ../../../../sing-box
    cp -r --no-preserve=all ${extraSources.sing-quic} ../../../../sing-quic
  '';

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
