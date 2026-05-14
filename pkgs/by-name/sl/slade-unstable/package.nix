{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  which,
  zip,
  wxwidgets_3_2,
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
  version = "3.2.12-unstable-2026-04-27";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    rev = "c948de8e48fe1b86fce8949f818a9ec5a499bd34";
    hash = "sha256-fcDYG8BPrdAYqK+YpVnYO5FkcdCKjqiyOhLpxEjet/0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    which
    zip
    wrapGAppsHook3
  ];

  buildInputs = [
    wxwidgets_3_2
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
    "-DwxWidgets_LIBRARIES=${wxwidgets_3_2}/lib"
    (lib.cmakeFeature "CL_WX_CONFIG" (lib.getExe' (lib.getDev wxwidgets_3_2) "wx-config"))
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
