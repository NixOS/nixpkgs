{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.1.3";
in
buildGoModule {
  pname = "goflow2";
  inherit version;

  src = fetchFromGitHub {
    owner = "netsampler";
    repo = "goflow2";
    rev = "v${version}";
    hash = "sha256-wtvBkk+Y4koGDGN+N/w4FsdejgpCIio0g2QV35Pr/fo=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  vendorHash = "sha256-qcWeIg278V2bgFGpWwUT5JCblxfBv0/gWV1oXul/nCQ=";

  meta = {
    description = "High performance sFlow/IPFIX/NetFlow Collector";
    homepage = "https://github.com/netsampler/goflow2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
