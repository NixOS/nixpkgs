{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  libGL,
  libX11,
  libxcb,
  xcb-util-cursor,
  xcbutil,
  xcbutilwm,
  xorgproto,
  xcbutilkeysyms,
  mesa,
  libconfig,
  nixosTests
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ragnarwm";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "cococry";
    repo = "Ragnar";
    rev = finalAttrs.version;
    hash = "sha256-c6MBdDujrSleXpvwTyne1AhCQD2TD4eWOr30SU4UwnA=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/cococry/ragnar/commit/901b4c4abffaf8136f47c2a479ffeafdad7164ac.patch?full_index=1";
      hash = "sha256-Fk9nQ8m9XS8ABvWtf6vdrA1ntLWT8B3SUbUB8vKnf0c=";
    })
    ./allow_system_wide_config.patch
  ];

  buildInputs = [
    libGL
    libX11
    libxcb
    xcbutil
    xcbutilwm
    xorgproto
    xcb-util-cursor
    xcbutilkeysyms
    mesa
    libconfig
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "PREFIX=${placeholder "out"}"
  ];

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/{bin,share/{applications,xsessions}}
  '';

  # ragnarstart is a demo script
  postInstall = "rm $out/bin/ragnarstart";

  passthru = {
    tests.ragnarwm = nixosTests.ragnarwm;
    providedSessions = [ "ragnar" ];
  };

  meta = {
    description = "Minimal, flexible & user-friendly X tiling window manager";
    homepage = "https://ragnarwm.org";
    changelog = "https://github.com/cococry/Ragnar/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "ragnar";
    platforms = lib.platforms.linux;
  };
})
