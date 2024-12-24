{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  bzip2,
}:

stdenv.mkDerivation rec {
  pname = "bsdiff";
  version = "4.3";

  src = fetchurl {
    url = "https://www.daemonology.net/bsdiff/${pname}-${version}.tar.gz";
    sha256 = "0j2zm3z271x5aw63mwhr3vymzn45p2vvrlrpm9cz2nywna41b0hq";
  };

  buildInputs = [ bzip2 ];
  patches =
    [
      (fetchpatch {
        url = "https://sources.debian.org/data/main/b/bsdiff/4.3-22/debian/patches/20-CVE-2014-9862.patch";
        sha256 = "sha256-3UuUfNvShQ8fLqxCKUTb/n4BmjL4+Nl7aEqCxYrrERQ=";
      })
      ./CVE-2020-14315.patch
      ./include-systypes.patch
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      (fetchpatch {
        url = "https://sources.debian.org/data/main/b/bsdiff/4.3-22/debian/patches/30-bug-632585-mmap-src-file-instead-of-malloc-read-it.patch";
        sha256 = "sha256-esbhz2/efUiuQDuF7LGfSeEn3/f1WbqCxQpTs2A0ulI=";
      })
      (fetchpatch {
        url = "https://sources.debian.org/data/main/b/bsdiff/4.3-22/debian/patches/31-bug-632585-mmap-dst-file-instead-of-malloc-read-it.patch";
        sha256 = "sha256-Of4aOcI0rsgdRzPqyw2VRn2p9wQuo3hdlgDTBdXGzoc=";
      })
      (fetchpatch {
        url = "https://sources.debian.org/data/main/b/bsdiff/4.3-22/debian/patches/32-bug-632585-use-int32_t-instead-off_t-for-file-size.patch";
        sha256 = "sha256-SooFnFK4uKNXvXQb/LEcH8GocnRtkryExI4b3BZTsAY=";
      })
    ];

  buildPhase = ''
    $CC -O3 -lbz2 bspatch.c -o bspatch
    $CC -O3 -lbz2 bsdiff.c  -o bsdiff
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1

    cp bsdiff    $out/bin
    cp bspatch   $out/bin
    cp bsdiff.1  $out/share/man/man1
    cp bspatch.1 $out/share/man/man1
  '';

  meta = with lib; {
    description = "Efficient binary diff/patch tool";
    homepage = "https://www.daemonology.net/bsdiff/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
