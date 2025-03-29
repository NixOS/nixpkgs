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
}:

stdenv.mkDerivation rec {
  version = "3.7.21";
  pname = "afflib";

  src = fetchFromGitHub {
    owner = "sshock";
    repo = "AFFLIBv3";
    rev = "v${version}";
    sha256 = "sha256-CBDkeUzHnRBkLUYl0JuQcVnQWap0l7dAca1deZVoNDM=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    zlib
    curl
    expat
    openssl
    python3
  ] ++ lib.optionals (with stdenv; isLinux || isDarwin) [ fuse ];

  meta = {
    homepage = "http://afflib.sourceforge.net/";
    description = "Advanced forensic format library";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsdOriginal;
    maintainers = [ lib.maintainers.raskin ];
    downloadPage = "https://github.com/sshock/AFFLIBv3/tags";
  };
}
