{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  pkg-config,
  cimg,
  libjpeg,
  libpng,
  nlohmann_json,
}:
let
  excludelist = fetchurl {
    url = "https://raw.githubusercontent.com/probonopd/AppImages/15a64c20dc23a0154622ba25829364323903b6b5/excludelist";
    sha256 = "sha256-UNsPiU80sWnEely8DBfbq2Hp7evKW8gmmh5qwb9L2tk=";
  };
in
stdenv.mkDerivation {
  pname = "linuxdeploy-plugin-qt";
  version = "0-unstable-2026-03-07";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "linuxdeploy";
    repo = "linuxdeploy-plugin-qt";
    rev = "511d51d066f632dfdfbcf0bf7284ec38090812d2";
    hash = "sha256-q/LL7XVtqCGyMxSFtHK7LinKF/TetYRtAfMpxZzPs6M=";
    fetchSubmodules = true;
  };

  patches = [
    # Deploy wayland-graphics-integration-client alongside wayland platform plugin
    # Without this, wayland EGL rendering fails
    # https://github.com/linuxdeploy/linuxdeploy-plugin-qt/issues/160
    ./wayland-fix.patch
  ];

  postPatch = ''
    substituteInPlace lib/linuxdeploy/src/core/generate-excludelist.sh \
      --replace-fail "wget --quiet \"\$url\" -O - " "cat ${excludelist}"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cimg
    libjpeg
    libpng
    nlohmann_json
  ];

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
  ];

  meta = {
    description = "Qt plugin for linuxdeploy to bundle Qt applications into AppImage format";
    homepage = "https://github.com/linuxdeploy/linuxdeploy-plugin-qt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ BatteredBunny ];
    mainProgram = "linuxdeploy-plugin-qt";
    platforms = lib.platforms.linux;
  };
}
