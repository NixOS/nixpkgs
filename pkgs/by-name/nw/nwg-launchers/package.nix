{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtkmm3,
  meson,
  ninja,
  nlohmann_json,
  pkg-config,
  swaylock,
  makeWrapper,
  gtk-layer-shell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nwg-launchers";
  version = "0.7.1.1";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-launchers";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-+waoJHU/QrVH7o9qfwdvFTFJzTGLcV9CeYPn3XHEAkM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    makeWrapper
  ];

  buildInputs = [
    gtkmm3
    nlohmann_json
    gtk-layer-shell
  ];

  postInstall = ''
    wrapProgram $out/bin/nwgbar \
      --prefix PATH : "${swaylock}/bin"
  '';

  meta = {
    description = "GTK-based launchers: application grid, button bar, dmenu for sway and other window managers";
    homepage = "https://github.com/nwg-piotr/nwg-launchers";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
