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
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "progress-tracker";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "smolBlackCat";
    repo = "progress-tracker";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uUw3+BJWRoCT1VH27SZBEBRsEbbpaP4IahKonfSOyeM=";
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
    pcre2
    tinyxml-2
  ];

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail "/usr/bin/" "${placeholder "out"}/bin/"

    substituteInPlace po/CMakeLists.txt \
      --replace-fail "/usr/share/" "${placeholder "out"}/share/"

    substituteInPlace data/CMakeLists.txt \
      --replace-fail "/usr/share/" "${placeholder "out"}/share/"
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
