{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  enableStatic ? true,
  enableShared ? !stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "libexecinfo";
  version = "1.1";

  src = fetchurl {
    url = "http://distcache.freebsd.org/local-distfiles/itetcu/${pname}-${version}.tar.bz2";
    sha256 = "07wvlpc1jk1sj4k5w53ml6wagh0zm9kv2l1jngv8xb7xww9ik8n9";
  };

  patches = [
    (fetchpatch {
      name = "10-execinfo.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/libexecinfo/10-execinfo.patch?id=730cdcef6901750f4029d4c3b8639ce02ee3ead1";
      sha256 = "0lnphrad4vspyljnvmm62dyxj98vgp3wabj4w3vfzfph7j8piw7g";
    })
    (fetchpatch {
      name = "20-define-gnu-source.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/libexecinfo/20-define-gnu-source.patch?id=730cdcef6901750f4029d4c3b8639ce02ee3ead1";
      sha256 = "1mp8mc639b0h2s69m5z6s2h3q3n1zl298j9j0plzj7f979j76302";
    })
    ./30-linux-makefile.patch
  ];

  makeFlags = [
    "CC:=$(CC)"
    "AR:=$(AR)"
  ];
  hardeningEnable = [ "stackprotector" ];

  buildFlags = lib.optional enableStatic "static" ++ lib.optional enableShared "dynamic";

  patchFlags = [ "-p0" ];

  installPhase = ''
    install -Dm644 execinfo.h stacktraverse.h -t $out/include
  ''
  + lib.optionalString enableShared ''
    install -Dm755 libexecinfo.so.1 -t $out/lib
    ln -s $out/lib/libexecinfo.so{.1,}
  ''
  + lib.optionalString enableStatic ''
    install -Dm755 libexecinfo.a -t $out/lib
  '';

  meta = with lib; {
    description = "Quick-n-dirty BSD licensed clone of the GNU libc backtrace facility";
    license = licenses.bsd2;
    homepage = "https://www.freshports.org/devel/libexecinfo";
    maintainers = [ ];
  };
}
