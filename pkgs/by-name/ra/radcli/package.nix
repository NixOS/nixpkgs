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
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "radcli";
    repo = "radcli";
    rev = "refs/tags/${version}";
    hash = "sha256-YnZkFYTiU2VNKxuP+JTnH64XYTB/+imeMKN1mZN9VCQ=";
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
    description = "Simple RADIUS client library";
    homepage = "https://github.com/radcli/radcli";
    changelog = "https://github.com/radcli/radcli/blob/${version}/NEWS";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
    mainProgram = "radcli";
    platforms = platforms.all;
  };
}
