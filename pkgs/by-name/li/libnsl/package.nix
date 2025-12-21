{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtirpc,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libnsl";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = "libnsl";
    rev = "v${version}";
    sha256 = "sha256-bCToqXVE4RZcoZ2eTNZcVHyzKlWyIpSAssQCOZcfmEA=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ libtirpc ];

  meta = {
    description = "Client interface library for NIS(YP) and NIS+";
    homepage = "https://github.com/thkukuk/libnsl";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.dezgeg ];
    platforms = lib.platforms.linux;
  };
}
