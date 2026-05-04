{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  gtk2,
  libhangul,
  autoconf,
  automake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nabi";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "libhangul";
    repo = "nabi";
    tag = "nabi-${finalAttrs.version}";
    hash = "sha256-U3W8G7cJ+lIqso6gSixmenX1cWnKuJO6dumUz4SUWi0=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
  ];

  buildInputs = [
    gtk2
    libhangul
  ];

  postPatch = ''
    patchShebangs ./autogen.sh
  '';

  preConfigure = ''
    ./autogen.sh
  '';

  meta = {
    description = "Easy Hangul XIM";
    mainProgram = "nabi";
    homepage = "https://github.com/libhangul/nabi";
    changelog = "https://github.com/libhangul/nabi/blob/nabi-${finalAttrs.version}/NEWS";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ianwookim ];
    platforms = lib.platforms.linux;
  };
})
