{
  lib,
  catch2_3,
  cmake,
  fetchFromGitHub,
  gtkmm4,
  libadwaita,
  pcre2,
  pkg-config,
  stdenv,
  tinyxml-2,
  wrapGAppsHook4,
  gettext,
  libuuid,
  spdlog,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "progress-tracker";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "smolBlackCat";
    repo = "progress-tracker";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-RIguUto0ADAT9OJ+gBf/JBpAiDn1DX9NBuGmDJYJn+Q=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook4
    gettext
  ];

  buildInputs = [
    catch2_3
    gtkmm4
    libadwaita
    pcre2
    tinyxml-2
    spdlog
    libuuid
  ];

  cmakeFlags = [
    "-DDEVELOPMENT=OFF"
    "-DBUILD_APP=ON"
  ];

  meta = {
    description = "Simple kanban-style task organiser";
    homepage = "https://github.com/smolBlackCat/progress-tracker";
    license = lib.licenses.mit;
    mainProgram = "progress";
    maintainers = with lib.maintainers; [ Guanran928 ];
    platforms = lib.platforms.linux;
  };
})
