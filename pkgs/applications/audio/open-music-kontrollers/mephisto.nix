{
  stdenv,
  lib,
  fetchFromSourcehut,
  pkg-config,
  cmake,
  meson,
  ninja,
  faust,
  fontconfig,
  glew,
  libvterm-neovim,
  lv2,
  lv2lint,
  sord,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mephisto";
  version = "0.18.2";

  src = fetchFromSourcehut {
    domain = "open-music-kontrollers.ch";
    owner = "~hp";
    repo = "mephisto.lv2";
    rev = finalAttrs.version;
    hash = "sha256-ab6OGt1XVgynKNdszzdXwJ/jVKJSzgSmAv6j1U3/va0=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    fontconfig
    cmake
  ];

  buildInputs = [
    faust
    libvterm-neovim
    lv2
    sord
    xorg.libX11
    xorg.libXext
    glew
    lv2lint
  ];

  meta = with lib; {
    description = "A Just-in-time FAUST embedded in an LV2 plugin";
    homepage = "https://git.open-music-kontrollers.ch/~hp/mephisto.lv2";
    license = licenses.artistic2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
})
