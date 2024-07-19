{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  version = "2.1.5";
in
buildGoModule {
  pname = "goflow2";
  inherit version;

  src = fetchFromGitHub {
    owner = "netsampler";
    repo = "goflow2";
    rev = "v${version}";
    hash = "sha256-Xo0SG9s39fPBGkPaVUbfWrHVVqZ7gQvjp4PJE/Z/jog=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  vendorHash = "sha256-6Wuf6trx8Epyv3FWAtEyAjGBM4OQyK0C8bpRWX0NUdo=";

  meta = {
    description = "High performance sFlow/IPFIX/NetFlow Collector";
    homepage = "https://github.com/netsampler/goflow2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ isabelroses ];
  };
}
