{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.2.1";
in
buildGoModule {
  pname = "goflow2";
  inherit version;

  src = fetchFromGitHub {
    owner = "netsampler";
    repo = "goflow2";
    rev = "v${version}";
    hash = "sha256-u2wdlmAwRqBPKD+aof34ud9O4aJ+4ccuMxyk8Cgpsp0=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  vendorHash = "sha256-4I4gIRJ80x9lmPpbJraSo1OD9CzT6povZDUAr1ZZEa0=";

  meta = with lib; {
    description = "High performance sFlow/IPFIX/NetFlow Collector";
    homepage = "https://github.com/netsampler/goflow2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ isabelroses ];
  };
}
