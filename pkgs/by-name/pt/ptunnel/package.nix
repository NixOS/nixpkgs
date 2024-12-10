{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  libpcap,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ptunnel";
  version = "0.72";

  src = fetchurl {
    url = "https://www.cs.uit.no/~daniels/PingTunnel/PingTunnel-${finalAttrs.version}.tar.gz";
    hash = "sha256-sxj3qn2IkYtiadBUp+JvBPl9iHD0e9Sadsssmcc0B6Q=";
  };

  patches = [
    # fix hyphen-used-as-minus-sign lintian warning in manpage.
    (fetchpatch {
      url = "https://salsa.debian.org/alteholz/ptunnel/-/raw/7475a32bc401056aeeb1b99e56b9ae5f1ee9c960/debian/patches/fix_minus_chars_in_man.patch";
      hash = "sha256-DcMsCZczO+SxOiQuFbdSJn5UH5E4TVf3+vupJ4OurVg=";
    })
    # fix typo in README file.
    (fetchpatch {
      url = "https://salsa.debian.org/alteholz/ptunnel/-/raw/7475a32bc401056aeeb1b99e56b9ae5f1ee9c960/debian/patches/fix_typo.diff";
      hash = "sha256-9cdOCfr2r9FnTmxJwvoClW5uf27j05zWQLykahKMJQg=";
    })
    # reverse parameters to memset.
    (fetchpatch {
      url = "https://salsa.debian.org/alteholz/ptunnel/-/raw/1dbf9b69507e19c86ac539fd8e3c60fc274717b3/debian/patches/memset-fix.patch";
      hash = "sha256-dYbuMM0/ZUgi3OxukBIp5rKhlwAjGu7cl/3w3sWr/xU=";
    })
  ];

  makeFlags = [
    "prefix=$(out)"
    "CC=cc"
  ];

  buildInputs = [
    libpcap
  ];

  meta = with lib; {
    description = "A tool for reliably tunneling TCP connections over ICMP echo request and reply packets";
    homepage = "https://www.cs.uit.no/~daniels/PingTunnel";
    license = licenses.bsd3;
    mainProgram = "ptunnel";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
  };
})
