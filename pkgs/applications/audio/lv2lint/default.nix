{
  stdenv,
  lib,
  fetchFromSourcehut,
  pkg-config,
  meson,
  ninja,
  lv2,
  lilv,
  curl,
  elfutils,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lv2lint";
  version = "0.16.2";

  src = fetchFromSourcehut {
    domain = "open-music-kontrollers.ch";
    owner = "~hp";
    repo = "lv2lint";
    rev = finalAttrs.version;
    hash = "sha256-NkzbKteLZ+P+Py+CMOYYipvu6psDslWnM1MAV1XB0TM=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    lv2
    lilv
    curl
    elfutils
    xorg.libX11
  ];

  mesonFlags = [
    (lib.mesonEnable "online-tests" true)
    (lib.mesonEnable "elf-tests" true)
    (lib.mesonEnable "x11-tests" true)
  ];

  meta = with lib; {
    description = "Check whether a given LV2 plugin is up to the specification";
    homepage = "https://git.open-music-kontrollers.ch/~hp/lv2lint";
    license = licenses.artistic2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    mainProgram = "lv2lint";
  };
})
