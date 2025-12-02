{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  pkg-config,
  cairo,
  file,
  hyprutils,
  libjpeg,
  libjxl,
  librsvg,
  libspng,
  libwebp,
  pango,
  pixman,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprgraphics";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprgraphics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JnET78yl5RvpGuDQy3rCycOCkiKoLr5DN1fPhRNNMco=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cairo
    file
    hyprutils
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
