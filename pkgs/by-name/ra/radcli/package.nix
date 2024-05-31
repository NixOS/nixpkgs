{
  lib,
  stdenv,
  autoreconfHook,
  doxygen,
  fetchFromGitHub,
  gettext,
  gnutls,
  libabigail,
  nettle,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "radcli";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "radcli";
    repo = "radcli";
    rev = "refs/tags/${version}";
    hash = "sha256-KBgimvhuHvaVh9hxPr+CtibGWyscSi0KXk8S1/STk+Q=";
  };

  postUnpack = ''
    touch ${src.name}/config.rpath
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    doxygen
    gettext
    gnutls
    libabigail
    nettle
  ];

  meta = with lib; {
    description = "A simple RADIUS client library";
    homepage = "https://github.com/radcli/radcli";
    changelog = "https://github.com/radcli/radcli/blob/${version}/NEWS";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
    mainProgram = "radcli";
    platforms = platforms.all;
  };
}
