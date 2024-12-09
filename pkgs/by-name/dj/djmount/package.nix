{ lib, stdenv, fetchurl, pkg-config, fuse }:

stdenv.mkDerivation rec {
  pname = "djmount";
  version = "0.71";
  src = fetchurl {
    url = "mirror://sourceforge/djmount/${version}/${pname}-${version}.tar.gz";
    sha256 = "0kqf0cy3h4cfiy5a2sigmisx0lvvsi1n0fbyb9ll5gacmy1b8nxa";
  };

  postPatch = ''
    # Taken from https://github.com/pupnp/pupnp/pull/334/files
    substituteInPlace libupnp/threadutil/inc/ithread.h \
      --replace \
        "#define ithread_mutexattr_setkind_np pthread_mutexattr_setkind_np" \
        '#define ithread_mutexattr_setkind_np pthread_mutexattr_settype'
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ fuse ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: libupnp/upnp/.libs/libupnp.a(libupnp_la-gena_ctrlpt.o):libupnp/upnp/src/inc/upnpapi.h:163:
  #     multiple definition of `pVirtualDirList'; libupnp/upnp/.libs/libupnp.a(libupnp_la-upnpapi.o):libupnp/upnp/src/inc/upnpapi.h:163: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  meta = {
    homepage = "https://djmount.sourceforge.net/";
    description = "UPnP AV client, mounts as a Linux filesystem the media content of compatible UPnP AV devices";
    mainProgram = "djmount";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.jagajaga ];
    license = lib.licenses.gpl2Plus;
  };
}
