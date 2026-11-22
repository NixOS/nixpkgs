{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  cpptrace,
  curl,
  fluidsynth,
  ftgl,
  glew,
  glm,
  gtk3,
  libarchive,
  libwebp,
  libxmp,
  lua5_5,
  md4c,
  mpg123,
  nlohmann_json,
  pkg-config,
  sfml_2,
  which,
  wrapGAppsHook3,
  wxwidgets_3_3,
  zip,
}:

let
  lua = lua5_5;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "slade";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    tag = finalAttrs.version;
    hash = "sha256-z8fkNtqts/RVSjsQKX5YGtmDSt8TZw7QXagME1/MgiU=";
  };

  patches = [ ./remove-fetchcontent.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
    which
    wrapGAppsHook3
    zip
  ];

  buildInputs = [
    cpptrace
    curl
    fluidsynth
    ftgl
    glew
    glm
    gtk3
    libarchive
    libwebp
    libxmp
    lua
    md4c
    mpg123
    nlohmann_json
    sfml_2
    wxwidgets_3_3
  ];

  cmakeFlags = [
    "-DwxWidgets_LIBRARIES=${wxwidgets_3_3}/lib"
    (lib.cmakeFeature "CL_WX_CONFIG" (lib.getExe' (lib.getDev wxwidgets_3_3) "wx-config"))
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-narrowing";

  # Force x11/xwayland to workaround the 3D view "spinning out" when running under wayland.
  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GDK_BACKEND : x11
    )
  '';

  meta = {
    description = "Doom editor";
    homepage = "http://slade.mancubus.net/";
    changelog = "https://github.com/sirjuddington/SLADE/releases/tag/${finalAttrs.version}";
    mainProgram = "slade";
    license = lib.licenses.gpl2Only; # https://github.com/sirjuddington/SLADE/issues/1754
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Gliczy ];
  };
})
