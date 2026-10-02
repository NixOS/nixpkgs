{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.2.7";
in
buildGoModule {
  pname = "goflow2";
  inherit version;

  src = fetchFromGitHub {
    owner = "netsampler";
    repo = "goflow2";
    rev = "v${version}";
    hash = "sha256-a8o9d8L4qkavCQang6Ukm5ColFAEn1DXow0BWoUJXms=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  vendorHash = "sha256-fhZ74kSCYd/7P9A9rdQhe8ejNIsFGuSQVO84tIRN+QY=";

  meta = {
    description = "High performance sFlow/IPFIX/NetFlow Collector";
    homepage = "https://github.com/netsampler/goflow2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
