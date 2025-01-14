{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  curl,
  expat,
  fuse,
  openssl,
  autoreconfHook,
  python3,
  libiconv,
}:

stdenv.mkDerivation rec {
  version = "3.7.20";
  pname = "afflib";

  src = fetchFromGitHub {
    owner = "sshock";
    repo = "AFFLIBv3";
    rev = "v${version}";
    sha256 = "sha256-xkqBfTftzn+rgeuoaKfHP7vQmy4VZuaCq8VFlfZTUE4=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs =
    [
      zlib
      curl
      expat
      openssl
      python3
    ]
    ++ lib.optionals (with stdenv; isLinux || isDarwin) [ fuse ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  meta = {
    homepage = "http://afflib.sourceforge.net/";
    description = "Advanced forensic format library";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsdOriginal;
    maintainers = [ lib.maintainers.raskin ];
    downloadPage = "https://github.com/sshock/AFFLIBv3/tags";
  };
}
