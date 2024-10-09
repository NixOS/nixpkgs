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
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dt5wL+v98Heg6395BOwNssXLXmoOKFnRXGqlOknYYPs=";
  };

  outputs = [ "out" ];

  meta = {
    description = "NSS module for glibc, to provide NIS support for glibc.";
    changelog = "https://github.com/thkukuk/${pname}/blob/master/NEWS";
    homepage = "https://github.com/thkukuk/${pname}";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ BarrOff ];
    platforms = lib.platforms.linux;
  };
}
