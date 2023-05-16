{ stdenv
, lib
, fetchFromGitea
, pkg-config
, meson
, ninja
, wayland-scanner
, wayland
, pixman
, wayland-protocols
, libxkbcommon
, scdoc
, tllist
, fcft
, enableCairo ? true
, svgSupport ? true
, pngSupport ? true
# Optional dependencies
, cairo
, libpng
}:

assert svgSupport -> enableCairo;

stdenv.mkDerivation rec {
  pname = "fuzzel";
<<<<<<< HEAD
  version = "1.9.2";
=======
  version = "1.9.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-X1P/ghX97KCQcrNk44Cy2IAGuZ8DDwHBWzh1AHLDvd4=";
=======
    hash = "sha256-Va/Rm35jqxDlIfQdrpZ41qrW8YzWmm1LWra76AW1xUw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    pkg-config
    wayland-scanner
    meson
    ninja
    scdoc
  ];

  buildInputs = [
    wayland
    pixman
    wayland-protocols
    libxkbcommon
    tllist
    fcft
  ] ++ lib.optional enableCairo cairo
    ++ lib.optional pngSupport libpng;

  mesonBuildType = "release";

  mesonFlags = [
    "-Denable-cairo=${if enableCairo then "enabled" else "disabled"}"
    "-Dpng-backend=${if pngSupport then "libpng" else "none"}"
    "-Dsvg-backend=${if svgSupport then "nanosvg" else "none"}"
  ];

  meta = with lib; {
<<<<<<< HEAD
    changelog = "https://codeberg.org/dnkl/fuzzel/releases/tag/${version}";
    description = "Wayland-native application launcher, similar to rofi’s drun mode";
    homepage = "https://codeberg.org/dnkl/fuzzel";
    license = with licenses; [ mit zlib ];
    mainProgram = "fuzzel";
    maintainers = with maintainers; [ fionera polykernel rodrgz ];
    platforms = with platforms; linux;
=======
    description = "Wayland-native application launcher, similar to rofi’s drun mode";
    homepage = "https://codeberg.org/dnkl/fuzzel";
    license = with licenses; [ mit zlib ];
    maintainers = with maintainers; [ fionera polykernel rodrgz ];
    platforms = with platforms; linux;
    changelog = "https://codeberg.org/dnkl/fuzzel/releases/tag/${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
