{ lib
, stdenv
, fetchurl
, fetchpatch
, autoconf

# for passthru.tests
, audacity
, mpd
, normalize
, ocamlPackages
, streamripper
, vlc
}:

stdenv.mkDerivation rec {
  pname = "libmad";
  version = "0.15.1b";

  src = fetchurl {
    url = "mirror://sourceforge/mad/${pname}-${version}.tar.gz";
    sha256 = "14460zhacxhswnzb36qfpd1f2wbk10qvksvm6wyq5hpvdgnw7ymv";
  };

  outputs = [ "out" "dev" ];

  patches = [
    (fetchpatch {
      url = "https://github.com/openwrt/packages/raw/openwrt-19.07/libs/libmad/patches/001-mips_removal_h_constraint.patch";
      sha256 = "0layswr6qg6axf4vyz6xrv73jwga34mkma3ifk9w9vrk41454hr5";
    })
    (fetchpatch {
      url = "https://github.com/KaOSx/main/raw/1270b8080f37fb6cca562829a521991800b0a497/libmad/libmad.patch";
      sha256 = "0rysq0sn3dfdz6pa6bfqkmk4ymc4rzk5ym7p16dyk37sldg1pbzs";
    })
    (fetchpatch {
      url = "https://github.com/KaOSx/main/raw/1270b8080f37fb6cca562829a521991800b0a497/libmad/amd64-64bit.diff";
      sha256 = "0mx56dmkbvw3zxnqd2hjng48q0d7q7473pns4n0ksdam29b0c5ar";
    })
    (fetchpatch {
      name = "CVE-2017-8372-CVE-2017-8373.patch";
      url = "https://github.com/openwrt/packages/raw/openwrt-19.07/libs/libmad/patches/102-CVE-2017-8373-CVE-2017-8372-md-size.patch";
      sha256 = "0p6mkpn66h1ds8jvww28q4vlr58jwm58m9vb7pkvvyvy764agqnk";
    })
    (fetchpatch {
      name = "CVE-2017-8374.patch";
      url = "https://github.com/openwrt/packages/raw/openwrt-19.07/libs/libmad/patches/101-CVE-2017-8374-length-check.patch";
      sha256 = "1j1ssxwmx9nfahzl62frbzck93xrjc2v3w30c12vmk29iflf1890";
    })
  ]
  # optimize.diff is taken from https://projects.archlinux.org/svntogit/packages.git/tree/trunk/optimize.diff?h=packages/libmad
  # It is included here in order to fix a build failure in Clang
  # But it may be useful to fix other, currently unknown problems as well
  ++ lib.optionals stdenv.cc.isClang [
    (fetchpatch {
      url = "https://github.com/KaOSx/main/raw/1270b8080f37fb6cca562829a521991800b0a497/libmad/optimize.diff";
      sha256 = "0hcxzz9ql1fizyqbsgdchdwi7bvchfr72172j43hpyj53p0yabc6";
    })
  ];

  # The -fforce-mem flag has been removed in GCC 4.3.
  postPatch = ''
    substituteInPlace configure.ac --replace "-fforce-mem" ""
    substituteInPlace configure.ac --replace "arch=\"-march=i486\"" ""
  '';

  nativeBuildInputs = [ autoconf ];

  preConfigure = "autoconf";

  passthru.tests = {
    inherit audacity mpd normalize streamripper vlc;
    ocaml-mad = ocamlPackages.mad;
  };

  meta = with lib; {
    homepage    = "https://sourceforge.net/projects/mad/";
    description = "High-quality, fixed-point MPEG audio decoder supporting MPEG-1 and MPEG-2";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
