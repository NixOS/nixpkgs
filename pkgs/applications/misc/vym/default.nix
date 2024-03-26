{ lib
, stdenv
, cmake
, fetchFromGitHub
, pkg-config
, qtbase
, qtscript
, qtsvg
, substituteAll
, unzip
, wrapQtAppsHook
, zip
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vym";
  version = "2.9.26";

  src = fetchFromGitHub {
    owner = "insilmaril";
    repo = "vym";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5cHhv9GDjJvSqGJ+7fI0xaWCiXw/0WP0Bem/ZRV8Y7M=";
  };

  outputs = [ "out" "man" ];

  patches = [
    (substituteAll {
      src = ./000-fix-zip-paths.diff;
      zipPath = "${zip}/bin/zip";
      unzipPath = "${unzip}/bin/unzip";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtscript
    qtsvg
  ];

  strictDeps = true;

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ unzip zip ]}"
  ];

  meta = {
    homepage = "http://www.insilmaril.de/vym/";
    description = "A mind-mapping software";
    mainProgram = "vym";
    longDescription = ''
      VYM (View Your Mind) is a tool to generate and manipulate maps which show
      your thoughts. Such maps can help you to improve your creativity and
      effectivity. You can use them for time management, to organize tasks, to
      get an overview over complex contexts, to sort your ideas etc.

      Maps can be drawn by hand on paper or a flip chart and help to structure
      your thoughs. While a tree like structure like shown on this page can be
      drawn by hand or any drawing software vym offers much more features to
      work with such maps.
    '';
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
