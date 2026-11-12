{
  lib,
  gcc16Stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  cairo,
  file,
  hyprutils,
  libGL,
  libdrm,
  libjpeg,
  libjxl,
  librsvg,
  libspng,
  libwebp,
  pango,
}:

gcc16Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprgraphics";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprgraphics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SdzBAddYgebEcMI9hnQim4SCgQJrFBi8ezyFXS5yJ40=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  propagatedBuildInputs = [
    cairo
    hyprutils
    libGL
    pango
  ];

  buildInputs = [
    file
    libdrm
    libjpeg
    libjxl
    librsvg
    libspng
    libwebp
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;
  strictDeps = true;

  cmakeBuildType = "RelWithDebInfo";
  separateDebugInfo = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/hyprwm/hyprgraphics";
    changelog = "https://github.com/hyprwm/hyprgraphics/releases/tag/${finalAttrs.src.tag}";
    description = "Cpp graphics library for Hypr* ecosystem";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
    teams = [ lib.teams.hyprland ];
  };
})
