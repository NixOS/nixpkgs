{ lib
, stdenv
, fetchFromGitHub
, cmake
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
  version = "2.8.42";

  src = fetchFromGitHub {
    owner = "insilmaril";
    repo = "vym";
    rev = "89f50bcba953c410caf459b0a4bfbd09018010b7"; # not tagged yet (why??)
    hash = "sha256-xMXvc8gt3nfKWbU+WoS24wCUTGDQRhG0Q9m7yDhY5/w=";
  };

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

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ unzip zip ]}"
  ];

  meta = with lib; {
    homepage = "http://www.insilmaril.de/vym/";
    description = "A mind-mapping software";
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
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
})
