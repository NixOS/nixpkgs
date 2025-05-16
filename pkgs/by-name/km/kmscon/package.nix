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
  pixman,
  pkg-config,
  docbook_xsl,
  libxslt,
  libgbm,
  ninja,
  check,
  buildPackages,
}:
stdenv.mkDerivation rec {
  pname = "kmscon";
  version = "9.1.0";

  src = fetchFromGitHub {
    owner = "Aetf";
    repo = "kmscon";
    rev = "v${version}";
    sha256 = "sha256-y9ccvM2QtkACdH4pDdC7wnURl5rvvoKqu+bud0kJdZA=";
  };

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
    pixman
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

  patches = [
    ./sandbox.patch # Generate system units where they should be (nix store) instead of /etc/systemd/system
  ];

  meta = with lib; {
    description = "KMS/DRM based System Console";
    mainProgram = "kmscon";
    homepage = "https://www.freedesktop.org/wiki/Software/kmscon/";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
