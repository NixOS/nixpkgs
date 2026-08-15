{
  lib,
  catch2_3,
  cmake,
  fetchFromGitHub,
  gtkmm4,
  libadwaita,
  libuuid,
  pkg-config,
  spdlog,
  stdenv,
  tinyxml-2,
  wrapGAppsHook4,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "progress-tracker";
  version = "1.7.3";

  src = fetchFromGitHub {
    owner = "smolBlackCat";
    repo = "progress-tracker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jFHB/YqdRlLihRWfxgap1OCZkbYqh5knfBzuEiWJjRY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    catch2_3
    gtkmm4
    libadwaita
    libuuid
    spdlog
    tinyxml-2
  ];

  cmakeFlags = [
    (lib.cmakeBool "DEVELOPMENT" false)
  ];

  postInstall = ''
    glib-compile-schemas "$out"/share/glib-2.0/schemas
  '';

  meta = {
    description = "Simple kanban-style task organiser";
    homepage = "https://github.com/smolBlackCat/progress-tracker";
    license = lib.licenses.mit;
    mainProgram = "progress";
    maintainers = with lib.maintainers; [ Guanran928 ];
    platforms = lib.platforms.linux;
  };
})
