{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libmnl,
  libnfnetlink,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.0.5";
  pname = "libnetfilter_queue";

  src = fetchurl {
    url = "https://www.netfilter.org/projects/libnetfilter_queue/files/libnetfilter_queue-${finalAttrs.version}.tar.bz2";
    sha256 = "1xdra6i4p8jkv943ygjw646qx8df27f7p5852kc06vjx608krzzr";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libmnl
    libnfnetlink
  ];

  meta = {
    homepage = "https://www.netfilter.org/projects/libnetfilter_queue/";
    description = "Userspace API to packets queued by the kernel packet filter";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
})
