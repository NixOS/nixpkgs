{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  cairo,
  file,
  hyprutils,
  lcms2,
  libGL,
  libdrm,
  libjpeg,
  libjxl,
  librsvg,
  libspng,
  libwebp,
  pango,
  pixman,
}:

gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprgraphics";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprgraphics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-48DubZbx8PDfuJkksNgi5aWFnX/Rq1OUaLsUvsdf2Bo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cairo
    file
    hyprutils
    lcms2
    libGL
    libdrm
    libjpeg
    libjxl
    librsvg
    libspng
    libwebp
    pango
    pixman
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/hyprwm/hyprgraphics";
    description = "Cpp graphics library for Hypr* ecosystem";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
    teams = [ lib.teams.hyprland ];
  };
})
