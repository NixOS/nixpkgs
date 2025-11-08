{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  libuuid,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "jfsutils";
  version = "1.1.15";

  src = fetchurl {
    url = "mirror://sourceforge/jfs/jfsutils-${version}.tar.gz";
    sha256 = "0kbsy2sk1jv4m82rxyl25gwrlkzvl3hzdga9gshkxkhm83v1aji4";
  };

  patches = [
    ./types.patch
    ./hardening-format.patch
    # required for cross-compilation
    ./ar-fix.patch
    # fix for glibc>=2.28
    (fetchpatch {
      name = "add_sysmacros.patch";
      url = "https://sources.debian.org/data/main/j/jfsutils/1.1.15-4/debian/patches/add_sysmacros.patch";
      sha256 = "1qcwvxs4d0d24w5x98z59arqfx2n7f0d9xaqhjcg6w8n34vkhnyc";
    })
    # fix for musl
    (fetchpatch {
      name = "musl-fix-includes.patch";
      url = "https://git.alpinelinux.org/aports/plain/main/jfsutils/musl-fix-includes.patch?id=567823dca7dc1f8ce919efbe99762d2d5c020124";
      sha256 = "sha256-FjdUOI+y+MdSWxTR+csH41uR0P+PWWTfIMPwQjBfQtQ=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libuuid ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #     ld: extract.o:/build/jfsutils-1.1.15/fscklog/extract.c:67: multiple definition of
  #       `xchklog_buffer'; display.o:/build/jfsutils-1.1.15/fscklog/display.c:57: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  # this required for wipefreespace
  postInstall = ''
    mkdir -p $out/include
    cp include/*.h $out/include
    mkdir -p $out/lib
    cp ./libfs/libfs.a $out/lib
  '';

  meta = with lib; {
    description = "IBM JFS utilities";
    homepage = "https://jfs.sourceforge.net";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
