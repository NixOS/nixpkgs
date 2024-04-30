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
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "irontec";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-gFba2wOU4GwpOZTo5A2QpBgnC6OgDJEeyaPGHbA+7tA=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2023-36192.patch";
      url = "https://github.com/irontec/sngrep/commit/ad1daf15c8387bfbb48097c25197bf330d2d98fc.patch";
      hash = "sha256-g8fxvxi3d7jmZEKTbxqw29hJbm/ShsKKxstsOUGxTug=";
    })
    ./1.7.0-CVE-2024-3119-CVE-2024-3120.patch
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

  doCheck = true;

  meta = with lib; {
    description = "A tool for displaying SIP calls message flows from terminal";
    homepage = "https://github.com/irontec/sngrep";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jorise ];
  };
}
