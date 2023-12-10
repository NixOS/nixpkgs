{ stdenv
, lib
, fetchurl
, dpkg
}:

stdenv.mkDerivation rec {
  pname = "sysbox";
  version = "0.6.2";

  src = fetchurl {
    url = "https://downloads.nestybox.com/sysbox/releases/v0.6.2/sysbox-ce_${version}-0.linux_amd64.deb";
    sha256 = "/Sh/LztaBytiw3j54e7uqizK0iu0jLOB0w2MhVxRtAE=";
  };

  nativeBuildInputs = [ dpkg ];

  unpackPhase = ''
    dpkg-deb -R $src .
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -rf usr/bin/* $out/bin/
  '';

  meta = with lib; {
    homepage = "https://github.com/nestybox/sysbox";
    description = "An open-source, next-generation 'runc' that empowers rootless containers to run workloads such as Systemd, Docker, Kubernetes, just like VMs.";
    license = licenses.asl20;
    maintainers = with maintainers; [ juliosueiras ];
  };
}
