{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.2.2";
in
buildGoModule {
  pname = "goflow2";
  inherit version;

  src = fetchFromGitHub {
    owner = "netsampler";
    repo = "goflow2";
    rev = "v${version}";
    hash = "sha256-H+YeW1FOx4hE8ad8sEWFQPxl8IOZ+xIaiSk1a5w+0+Y=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  vendorHash = "sha256-AR4jKNzHato9qz0fkHurGGfIyQC9BYsGQ/87y9mtJpE=";

  meta = {
    description = "High performance sFlow/IPFIX/NetFlow Collector";
    homepage = "https://github.com/netsampler/goflow2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
