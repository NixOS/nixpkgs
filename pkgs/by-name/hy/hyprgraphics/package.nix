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
  libspng,
  libwebp,
  pixman,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyprgraphics";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprgraphics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gbh1HL98Fdqu0jJIWN4OJQN7Kkth7+rbkFpSZLm/62A=";
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
    libspng
    libwebp
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
