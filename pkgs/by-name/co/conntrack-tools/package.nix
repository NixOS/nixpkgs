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
<<<<<<< HEAD
  systemdLibs,
=======
  systemd,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    systemdLibs
=======
    systemd
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];
  nativeBuildInputs = [
    flex
    bison
    pkg-config
  ];

  configureFlags = [
    (lib.enableFeature systemdSupport "systemd")
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://conntrack-tools.netfilter.org/";
    description = "Connection tracking userspace tools";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fpletz ];
=======
  meta = with lib; {
    homepage = "https://conntrack-tools.netfilter.org/";
    description = "Connection tracking userspace tools";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
