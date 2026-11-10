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
}:
let
  excludelist = fetchurl {
    url = "https://raw.githubusercontent.com/probonopd/AppImages/15a64c20dc23a0154622ba25829364323903b6b5/excludelist";
    sha256 = "sha256-UNsPiU80sWnEely8DBfbq2Hp7evKW8gmmh5qwb9L2tk=";
  };
in
stdenv.mkDerivation {
  pname = "linuxdeploy";
  version = "0-unstable-2026-04-12";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "linuxdeploy";
    repo = "linuxdeploy";
    rev = "8dccfe12c273bb598937fcea6da46c0d29d84452";
    hash = "sha256-gP9yZwrgpRZ4BBYvSnC306iWaV+1cOVxdpxlEBE7aHE=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace src/core/generate-excludelist.sh \
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
  ];

  meta = {
    description = "Tool to bundle Linux applications into AppImage format";
    homepage = "https://github.com/linuxdeploy/linuxdeploy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ BatteredBunny ];
    mainProgram = "linuxdeploy";
    platforms = lib.platforms.linux;
  };
}
