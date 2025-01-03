{
  stdenv,
  lib,
  fetchFromGitHub,
  autoreconfHook,
  libxcrypt,
  libnsl,
  libtirpc,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "libnss_nis";
  version = "3.2";

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libxcrypt
    libnsl
    libtirpc
  ];

  src = fetchFromGitHub {
    owner = "thkukuk";
    repo = "libnss_nis";
    rev = "v${version}";
    hash = "sha256-dt5wL+v98Heg6395BOwNssXLXmoOKFnRXGqlOknYYPs=";
  };

  outputs = [ "out" ];

  meta = {
    description = "NSS module for glibc, to provide NIS support for glibc";
    changelog = "https://github.com/thkukuk/libnss_nis/blob/master/NEWS";
    homepage = "https://github.com/thkukuk/libnss_nis";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ BarrOff ];
    platforms = lib.platforms.linux;
  };
}
