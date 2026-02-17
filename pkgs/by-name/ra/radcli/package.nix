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

stdenv.mkDerivation (finalAttrs: {
  pname = "radcli";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "radcli";
    repo = "radcli";
    tag = finalAttrs.version;
    hash = "sha256-YnZkFYTiU2VNKxuP+JTnH64XYTB/+imeMKN1mZN9VCQ=";
  };

  postUnpack = ''
    touch ${finalAttrs.src.name}/config.rpath
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

  meta = {
    description = "Simple RADIUS client library";
    homepage = "https://github.com/radcli/radcli";
    changelog = "https://github.com/radcli/radcli/blob/${finalAttrs.version}/NEWS";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "radcli";
    platforms = lib.platforms.all;
  };
})
