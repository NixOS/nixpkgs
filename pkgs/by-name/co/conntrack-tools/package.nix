{
  fetchurl,
  lib,
  stdenv,
  flex,
  bison,
  pkg-config,
  libmnl,
  libnfnetlink,
  libnetfilter_conntrack,
  libnetfilter_queue,
  libnetfilter_cttimeout,
  libnetfilter_cthelper,
  libtirpc,
  systemdSupport ? true,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "conntrack-tools";
  version = "1.4.8";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/conntrack-tools/files/${pname}-${version}.tar.xz";
    hash = "sha256-BnZ39MX2VkgZ547TqdSomAk16pJz86uyKkIOowq13tY=";
  };

  buildInputs = [
    libmnl
    libnfnetlink
    libnetfilter_conntrack
    libnetfilter_queue
    libnetfilter_cttimeout
    libnetfilter_cthelper
    libtirpc
  ]
  ++ lib.optionals systemdSupport [
    systemd
  ];
  nativeBuildInputs = [
    flex
    bison
    pkg-config
  ];

  configureFlags = [
    (lib.enableFeature systemdSupport "systemd")
  ];

  meta = {
    homepage = "https://conntrack-tools.netfilter.org/";
    description = "Connection tracking userspace tools";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fpletz ];
  };
}
