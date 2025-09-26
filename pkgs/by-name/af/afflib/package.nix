{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
  curl,
  expat,
  fuse3,
  openssl,
  autoreconfHook,
  python3,
  libiconv,
}:

stdenv.mkDerivation rec {
  version = "3.7.22";
  pname = "afflib";

  src = fetchFromGitHub {
    owner = "sshock";
    repo = "AFFLIBv3";
    tag = "v${version}";
    sha256 = "sha256-pGInhJQBhFJhft/KfB3J3S9/BVp9D8TZ+uw2CUNVC+Q=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    zlib
    curl
    expat
    openssl
    python3
  ]
  ++ lib.optionals (with stdenv; isLinux || isDarwin) [ fuse3 ]
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
