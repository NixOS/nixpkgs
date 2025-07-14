{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.2.3";
in
buildGoModule {
  pname = "goflow2";
  inherit version;

  src = fetchFromGitHub {
    owner = "netsampler";
    repo = "goflow2";
    rev = "v${version}";
    hash = "sha256-nLsl3v4pvFa0d4AejjlUY9y92yKCU3jM5ui2Y+qZ3JY=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  vendorHash = "sha256-E7gWeh8GVFQdxLSZhpl5wAaShooKkC9EJJsulGaoBtE=";

  meta = {
    description = "High performance sFlow/IPFIX/NetFlow Collector";
    homepage = "https://github.com/netsampler/goflow2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
