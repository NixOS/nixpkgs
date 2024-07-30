{
  lib,
  stdenv,
  fetchFromGitHub,
  pixman,
  fcft,
  pkg-config,
  wayland-protocols,
  wayland-scanner,
  wayland
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sandbar";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "kolunmi";
    repo = "sandbar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uG+/e75s/OQtEotR+8aXTEjW6p3oJM8btuRNgUVmIiQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    wayland-scanner
    wayland-protocols
    wayland
    pixman
    fcft
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/kolunmi/sandbar";
    description = "DWM-like bar for the river wayland compositor";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fccapria ];
    platforms = platforms.all;
    badPlatforms = platforms.darwin;
    mainProgram = "sandbar";
  };
})
