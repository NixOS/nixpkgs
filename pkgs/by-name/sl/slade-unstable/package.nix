{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  which,
  zip,
  wxGTK32,
  gtk3,
  sfml_2,
  fluidsynth,
  curl,
  ftgl,
  glew,
  lua,
  mpg123,
  wrapGAppsHook3,
  unstableGitUpdater,
  libwebp,
}:

stdenv.mkDerivation {
  pname = "slade";
  version = "3.2.11-unstable-2026-02-10";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = "b2c302bb9723a7ef12315c299244874249f4f13b";
    hash = "sha256-lUyDsJb2DXCSwRp7G9YF9aAWhJ7a2mXriTPmQ2/nhaQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    which
    zip
    wrapGAppsHook3
  ];

  buildInputs = [
    wxGTK32
    gtk3
    sfml_2
    fluidsynth
    curl
    ftgl
    glew
    lua
    mpg123
    libwebp
  ];

  cmakeFlags = [
    "-DwxWidgets_LIBRARIES=${wxGTK32}/lib"
    (lib.cmakeFeature "CL_WX_CONFIG" (lib.getExe' (lib.getDev wxGTK32) "wx-config"))
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GDK_BACKEND : x11
    )
  '';

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/sirjuddington/SLADE.git";
  };

  meta = {
    description = "Doom editor";
    homepage = "http://slade.mancubus.net/";
    mainProgram = "slade";
    license = lib.licenses.gpl2Only; # https://github.com/sirjuddington/SLADE/issues/1754
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Gliczy ];
  };
}
