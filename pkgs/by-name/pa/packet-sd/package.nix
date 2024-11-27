{ buildGoModule
, fetchFromGitHub
, fetchpatch2
, lib
}:

buildGoModule rec {
  pname = "prometheus-packet-sd";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "packethost";
    repo = "prometheus-packet-sd";
    rev = "v${version}";
    hash = "sha256-2k8AsmyhQNNZCzpVt6JdgvI8IFb5pRi4ic6Yn2NqHMM=";
  };

  patches = [
    (fetchpatch2 {
      # fix racy permissions on outfile
      # https://github.com/packethost/prometheus-packet-sd/issues/15
      url = "https://github.com/packethost/prometheus-packet-sd/commit/bf0ed3a1da4d0f797bd29e4a1857ac65a1d04750.patch";
      hash = "sha256-ZLV9lyqZxpIQ1Cmzy/nY/85b4QWF5Ou0XcdrZXxck2E=";
    })
    (fetchpatch2 {
      # restrict outfile to not be world/group writable
      url = "https://github.com/packethost/prometheus-packet-sd/commit/a0afc2a4c3f49dc234d0d2c4901df25b4110b3ec.patch";
      hash = "sha256-M5133+r77z21/Ulnbz+9sGbbuY5UpU1+22iY464UVAU=";
    })
    (fetchpatch2 {
      # apply chmod to tmpfile, not the outfile, that does not exist at that point
      url = "https://github.com/packethost/prometheus-packet-sd/commit/41977f11b449677497a93456c499916c68e56334.patch";
      hash = "sha256-ffXxbwatKBw7G1fdmsZaT7WX4OmYFMJnueL/kEKc1VE=";
    })
  ];

  vendorHash = null;

  subPackages = [ "." ];

  meta = with lib; {
    description = "Prometheus service discovery for Equinix Metal";
    homepage = "https://github.com/packethost/prometheus-packet-sd";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "prometheus-packet-sd";
  };
}
