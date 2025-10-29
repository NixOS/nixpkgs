{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cdrtools,
  m4,
}:

stdenv.mkDerivation rec {
  pname = "dvd+rw-tools";
  version = "7.1";

  src = fetchurl {
    url = "http://fy.chalmers.se/~appro/linux/DVD+RW/tools/${pname}-${version}.tar.gz";
    sha256 = "1jkjvvnjcyxpql97xjjx0kwvy70kxpiznr2zpjy2hhci5s10zmpq";
  };

  patches = [
    ./darwin.patch
  ]
  # Patches from Gentoo
  ++
    map
      (
        { pfile, sha256 }:
        fetchpatch {
          url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-cdr/dvd+rw-tools/files/${pfile}?id=b510df361241e8f16314b1f14642305f0111dac6";
          inherit sha256;
        }
      )
      [
        {
          pfile = "dvd+rw-tools-7.0-dvddl-r1.patch";
          sha256 = "12l33jq6405shfwdycrj52qmd07h5bsp1vjaddknfri456azjny5";
        }
        {
          pfile = "dvd+rw-tools-7.0-glibc2.6.90.patch";
          sha256 = "1fb3gap2in782pa4164h1w0ha8ggsq3inissa1k0zn2p2r3rb5ln";
        }
        {
          pfile = "dvd+rw-tools-7.0-reload.patch";
          sha256 = "12v2y2y6ci5hh6lbmsk97dzgznrm4bxwhc81mq684ix0qspb9mq4";
        }
        {
          pfile = "dvd+rw-tools-7.0-sysmacros.patch";
          sha256 = "1rkb26cyhfxklkmna3l9b4797f6gzlxyqqin44jwnq3jmwfrs6v0";
        }
        {
          pfile = "dvd+rw-tools-7.0-wctomb-r1.patch";
          sha256 = "1xg770l0b4bjn30y7nqg619v4m5ickcn2n8hv9k2an6r191daq58";
        }
        {
          pfile = "dvd+rw-tools-7.0-wexit.patch";
          sha256 = "0sqzlkm19fmjx4lzxkxwn2ymrj9fq0zk0jkys3xm6xvd2ibb6kxl";
        }
        {
          pfile = "dvd+rw-tools-7.1-bluray_pow_freespace.patch";
          sha256 = "0iscz8fs5002ymk6wl2fz4x06b7bdnc57rfz8kbv3216acqi5rv3";
        }
        {
          pfile = "dvd+rw-tools-7.1-bluray_srm+pow.patch";
          sha256 = "0sy40m12w987i6g0cyxv8cfmab4vp7cd222lv05apknfi2y7smmw";
        }
        {
          pfile = "dvd+rw-tools-7.1-lastshort.patch";
          sha256 = "01wspv70sil20khkg5kj086b1x8rrig4yhcq9s88bdjd42nv0vpx";
        }
        {
          pfile = "dvd+rw-tools-7.1-noevent.patch";
          sha256 = "1kbmxpg15wci33f2h6pxxvf3qm0kpyzx9wj5a3l67sk34hvza3z6";
        }
      ];

  nativeBuildInputs = [ m4 ];
  buildInputs = [ cdrtools ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      # error: invalid suffix on literal; C++11 requires a space between literal and identifier
      "-Wno-reserved-user-defined-literal"
      # error: non-constant-expression cannot be narrowed from type 'size_t' (aka 'unsigned long') to 'IOByteCount' (aka 'unsigned int') in initializer list
      "-Wno-c++11-narrowing"
    ]
  );

  meta = with lib; {
    homepage = "http://fy.chalmers.se/~appro/linux/DVD+RW/tools";
    description = "Tools for mastering Blu-ray and DVD+-RW/+-R media";
    platforms = platforms.unix;
    license = with licenses; [
      gpl2Only
      publicDomain
    ];
  };
}
