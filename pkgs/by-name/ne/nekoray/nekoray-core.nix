{
  buildGoModule,
  version,
  src,
  extraSources,
}:

buildGoModule rec {
  pname = "nekoray-core";
  inherit version src;
  sourceRoot = "${src.name}/go/cmd/nekoray_core";

  postPatch = ''
    cp -r --no-preserve=all ${extraSources.libneko} ../../../../libneko
    cp -r --no-preserve=all ${extraSources.Xray-core} ../../../../Xray-core
  '';

  vendorHash = "sha256-gxp5oI7qO+bdSe8Yrb9I4Wkl5TqqZeIhzcQDg1OpRkc=";

  ldflags = [
    "-w"
    "-s"
    "-X github.com/matsuridayo/libneko/neko_common.Version_neko=${version}"
    "-X github.com/matsuridayo/libneko/neko_common.Version_v2ray=${extraSources.Xray-core.rev}"
  ];
}
