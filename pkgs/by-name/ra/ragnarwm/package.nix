{
  lib,
  stdenv,
  fetchFromGitHub,
  libX11,
  libGL,
  libxcb,
  libXmu,
  xcbutilcursor,
  xcbutil,
  xcbutilwm,
  xcbutilkeysyms,
  libconfig,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ragnarwm";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "cococry";
    repo = "Ragnar";
    rev = "76ea5f20b453dab5442a97719deae0c194912e24"; # no tags
    hash = "sha256-ghqkZL9+PmINc0Vqmn4eywJr9yrVUH3lRhKUg4MBr+Q=";
  };

  preBuild = ''
    rm api/lib/{api.o,libragnar.a}
  '';

  buildInputs = [
    libxcb
    xcbutil
    xcbutilkeysyms
    libXmu
    xcbutilcursor
    libX11
    xcbutilwm
    libGL
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
    homepage = "https://ragnar-website.vercel.app";
    changelog = "https://github.com/cococry/Ragnar/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "ragnar";
    platforms = lib.platforms.linux;
  };
})
