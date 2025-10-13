{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch2,
  pkg-config,
  libglut,
  gtk2,
  gtkglext,
  libjpeg_turbo,
  libtheora,
  libXmu,
  lua,
  libGLU,
  libGL,
  perl,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "celestia";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "CelestiaProject";
    repo = "Celestia";
    rev = version;
    sha256 = "sha256-MkElGo1ZR0ImW/526QlDE1ePd+VOQxwkX7l+0WyZ6Vs=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/CelestiaProject/Celestia/commit/94894bed3bf98d41c5097e7829d491d8ff8d4a62.patch?full_index=1";
      hash = "sha256-hEZ6BhSEx6Qm+fLisc63xSCDT6GX92AHD0BuldOhzFk=";
    })
  ];

  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail "dnl AM_GNU_GETTEXT_VERSION([0.15])" "AM_GNU_GETTEXT_VERSION([0.15])"
  '';

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    libglut
    gtk2
    gtkglext
    lua
    perl
    libjpeg_turbo
    libtheora
    libXmu
    libGLU
    libGL
  ];

  configureFlags = [
    "--with-gtk"
    "--with-lua=${lua}"
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://celestiaproject.space/";
    description = "Real-time 3D simulation of space";
    mainProgram = "celestia";
    changelog = "https://github.com/CelestiaProject/Celestia/releases/tag/${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      returntoreality
    ];
    platforms = lib.platforms.linux;
  };
}
