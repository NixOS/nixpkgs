{
  stdenv,
  fetchurl,
  fetchpatch,
  ncurses ? null,
  perl ? null,
  lib,
}:

stdenv.mkDerivation rec {
  pname = "liboping";
  version = "1.10.0";

  src = fetchurl {
    url = "https://noping.cc/files/${pname}-${version}.tar.bz2";
    sha256 = "1n2wkmvw6n80ybdwkjq8ka43z2x8mvxq49byv61b52iyz69slf7b";
  };

  patches = [
    # Add support for ncurses-6.3. A backport of patch pending upstream
    # inclusion: https://github.com/octo/liboping/pull/61
    ./ncurses-6.3.patch

    # Pull pending fix for format arguments mismatch:
    #  https://github.com/octo/liboping/pull/60
    (fetchpatch {
      name = "format-args.patch";
      url = "https://github.com/octo/liboping/commit/7a50e33f2a686564aa43e4920141e6f64e042df1.patch";
      sha256 = "118fl3k84m3iqwfp49g5qil4lw1gcznzmyxnfna0h7za2nm50cxw";
    })
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isGNU "-Wno-error=format-truncation";

  buildInputs = [
    ncurses
    perl
  ];

  configureFlags = lib.optional (perl == null) "--with-perl-bindings=no";

  meta = with lib; {
    description = "C library to generate ICMP echo requests (a.k.a. ping packets)";
    longDescription = ''
      liboping is a C library to generate ICMP echo requests, better known as
      "ping packets". It is intended for use in network monitoring applications
      or applications that would otherwise need to fork ping(1) frequently.
      Included is a sample application, called oping, which demonstrates the
      library's abilities.
    '';
    homepage = "http://noping.cc/";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
