{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  which,
  zip,
  wxwidgets_3_3,
  gtk3,
  sfml_2,
  fluidsynth,
  curl,
  ftgl,
  glew,
  lua5_5,
  mpg123,
  wrapGAppsHook3,
  libwebp,
  glm,
  libxmp,
  libarchive,
  cpptrace,
  nlohmann_json,
  md4c,
}:

let
  lua = lua5_5;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "slade";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "sirjuddington";
    repo = "SLADE";
    tag = finalAttrs.version;
    hash = "sha256-keh3dkgUovNwMyQRJvrMN2iZSBGrwKSsdeNbxaZQiE8=";
  };

  patches = [ ./remove-fetchcontent.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
    which
    zip
    wrapGAppsHook3
  ];

  buildInputs = [
    wxwidgets_3_3
    gtk3
    sfml_2
    fluidsynth
    curl
    ftgl
    glew
    lua
    mpg123
    libwebp
    glm
    libxmp
    libarchive
    cpptrace
    nlohmann_json
    md4c
  ];

  cmakeFlags = [
    "-DwxWidgets_LIBRARIES=${wxwidgets_3_3}/lib"
    (lib.cmakeFeature "CL_WX_CONFIG" (lib.getExe' (lib.getDev wxwidgets_3_3) "wx-config"))
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-narrowing";

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
