{ lib
, stdenv
, fetchzip
, substituteAll
, cmake
, extra-cmake-modules
, qttools
, kwayland
, leptonica
, tesseract4
, qtmultimedia
, qtx11extras
, qttranslations
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "crow-translate";
  version = "2.9.12";

  src = fetchzip {
    url = "https://github.com/${pname}/${pname}/releases/download/${version}/${pname}-${version}-source.tar.gz";
    hash = "sha256-JkAykc5j5HMkK48qAm876A2zBD095CG/yR4TyXAdevM=";
  };

  patches = [
    (substituteAll {
      # See https://github.com/NixOS/nixpkgs/issues/86054
      src = ./fix-qttranslations-path.patch;
      inherit qttranslations;
    })
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    kwayland
    leptonica
    tesseract4
    qtmultimedia
    qtx11extras
  ];

  postInstall = ''
    substituteInPlace $out/share/applications/io.crow_translate.CrowTranslate.desktop \
      --replace "Exec=qdbus" "Exec=${lib.getBin qttools}/bin/qdbus"
  '';

  meta = with lib; {
    description = "A simple and lightweight translator that allows to translate and speak text using Google, Yandex and Bing";
    homepage = "https://crow-translate.github.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
}
