{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  libtsm,
  systemdLibs,
  libxkbcommon,
  libdrm,
  libGLU,
  libGL,
  pango,
  pkg-config,
  docbook_xsl,
  libxslt,
  libgbm,
  ninja,
  check,
  buildPackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "kmscon";
  version = "9.1.0-unstable-2025-12-04";

  src = fetchFromGitHub {
    owner = "Aetf";
    repo = "kmscon";
    rev = "04dca3ce1453c186a9020d64fadf8d984d2143bc";
    sha256 = "sha256-bwmXXSBV+j4mpnAAmZ9SwFqWNY4LKwLYvh2zVJMO0fU=";
  };

  patches = [
    ./sandbox.patch # Generate system units where they should be (nix store) instead of /etc/systemd/system
  ];

  strictDeps = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  buildInputs = [
    libGLU
    libGL
    libdrm
    libtsm
    libxkbcommon
    pango
    systemdLibs
    libgbm
    check
  ];

  nativeBuildInputs = [
    meson
    ninja
    docbook_xsl
    pkg-config
    libxslt # xsltproc
  ];

  env.NIX_CFLAGS_COMPILE =
    lib.optionalString stdenv.cc.isGNU "-O "
    + "-Wno-error=maybe-uninitialized -Wno-error=unused-result -Wno-error=implicit-function-declaration";

  enableParallelBuilding = true;

  meta = with lib; {
    description = "KMS/DRM based System Console";
    mainProgram = "kmscon";
    homepage = "https://www.freedesktop.org/wiki/Software/kmscon/";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
})
