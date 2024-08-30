{
  buildGoModule,
  version,
  src,
}:

buildGoModule rec {
  pname = "nekoray-core";
  inherit version src;

  sourceRoot = "${src.name}/nekoray/go/cmd/nekoray_core";

  vendorHash = "sha256-gxp5oI7qO+bdSe8Yrb9I4Wkl5TqqZeIhzcQDg1OpRkc=";

  ldflags = [
    "-w"
    "-s"
    "-X github.com/matsuridayo/libneko/neko_common.Version_neko=${version}"
    "-X github.com/matsuridayo/libneko/neko_common.Version_v2ray=???"
  ];
}
