{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libvirt,
}:

buildGoModule rec {
  pname = "prometheus-libvirt-exporter";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "Tinkoff";
    repo = "libvirt-exporter";
    rev = "refs/tags/${version}";
    hash = "sha256-loh7fgeF1/OuTt2MQSkl/7VnX25idoF57+HtzV9L/ns=";
  };

  vendorHash = null;

  ldflags = [ "-X=main.Version=${version}" ];

  buildInputs = [ libvirt ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Prometheus metrics exporter for libvirt";
    homepage = "https://github.com/Tinkoff/libvirt-exporter";
    license = licenses.asl20;
    maintainers = with maintainers; [ farcaller ];
  };
}
