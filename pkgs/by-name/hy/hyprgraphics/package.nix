{
  lib,
  gcc14Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  cairo,
  file,
  hyprutils,
  libjpeg,
  libjxl,
  libwebp,
  pixman,
}:

gcc14Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprgraphics";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprgraphics";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FFLJzFTyNhS7tBEEECx0B8Ye/bpmxhFVEKlECgMLc6c=";
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
    libwebp
    pixman
  ];

  outputs = [
    "out"
    "dev"
  ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/hyprwm/hyprlang";
    description = "Official implementation library for the hypr config language";
    license = licenses.lgpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [
      fufexan
      khaneliman
    ];
  };
})
