{ lib
, stdenv
, autoconf
, automake
, fetchFromGitHub
, fetchpatch
, libpcap
, ncurses
, openssl
, pcre
}:

stdenv.mkDerivation rec {
  pname = "sngrep";
  version = "1.4.9";

  src = fetchFromGitHub {
    owner = "irontec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-92wPRDFSoIOYFv3XKdsuYH8j3D8kXyg++q6VpIIMGDg=";
  };

  patches = [
    # Pull fix pending upstream inclusion for ncurses-6.3 support:
    #  https://github.com/irontec/sngrep/pull/382
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/irontec/sngrep/commit/d09e1c323dbd7fc899e8985899baec568f045601.patch";
      sha256 = "sha256-nY5i3WQh/oKboEAh4wvxF5Imf2BHYEKdFj+WF1M3SSA=";
    })
  ];

  nativeBuildInputs = [
    autoconf
    automake
  ];

  buildInputs = [
    libpcap
    ncurses
    ncurses
    openssl
    pcre
  ];

  configureFlags = [
    "--with-pcre"
    "--enable-unicode"
    "--enable-ipv6"
    "--enable-eep"
  ];

  preConfigure = ''
    ./bootstrap.sh
  '';

  meta = with lib; {
    description = "A tool for displaying SIP calls message flows from terminal";
    homepage = "https://github.com/irontec/sngrep";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jorise ];
  };
}
