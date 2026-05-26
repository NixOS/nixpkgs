{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libassuan,
  libgpg-error,
  popt,
  bemenu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pinentry-bemenu";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "t-8ch";
    repo = "pinentry-bemenu";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-kiGUCcQIS58XjE4r0yiK4hJ85Sg5wrtBqeSYcgUKAmo=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    libassuan
    libgpg-error
    popt
    bemenu
  ];

  meta = {
    description = "Pinentry implementation based on bemenu";
    homepage = "https://github.com/t-8ch/pinentry-bemenu";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jc ];
    platforms = with lib.platforms; linux;
    mainProgram = "pinentry-bemenu";
  };
})
