{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  rofi-unwrapped,
  libqalculate,
  glib,
  cairo,
  gobject-introspection,
  wrapGAppsHook3,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "rofi-calc";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "rofi-calc";
    rev = "v${version}";
    sha256 = "sha256-/UKOyJfCsV/+kZDndHZmrPdE2MjVlQWSiWQRIUPGz/I=";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    wrapGAppsHook3
    meson
    ninja
  ];

  buildInputs = [
    rofi-unwrapped
    libqalculate
    glib
    cairo
  ];

  mesonBuildType = "release";

  postPatch = ''
    substituteInPlace src/calc.c --replace-fail \
      "qalc_binary = \"qalc\"" \
      "qalc_binary = \"${lib.getExe libqalculate}\""

    substituteInPlace src/meson.build --replace-fail \
      "rofi.get_variable('pluginsdir')" \
      "'$out/lib/rofi'"
  '';

<<<<<<< HEAD
  meta = {
    description = "Do live calculations in rofi";
    homepage = "https://github.com/svenstaro/rofi-calc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ albakham ];
    platforms = with lib.platforms; linux;
=======
  meta = with lib; {
    description = "Do live calculations in rofi";
    homepage = "https://github.com/svenstaro/rofi-calc";
    license = licenses.mit;
    maintainers = with maintainers; [ albakham ];
    platforms = with platforms; linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
