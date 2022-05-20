{ lib
, stdenv
, nix-update-script
, fetchFromGitHub
, substituteAll
, cmake
, extra-cmake-modules
, qttools
, leptonica
, tesseract4
, qtmultimedia
, qtx11extras
, qttranslations
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "crow-translate";
  version = "2.9.5";

  src = fetchFromGitHub {
    owner = "crow-translate";
    repo = pname;
    rev = version;
    sha256 = "sha256-AzwJJ85vxXsc0+W3QM8citN5f0AD6APQVd9628cfLgI=";
    fetchSubmodules = true;
  };

  patches = [
    (substituteAll {
      # See https://github.com/NixOS/nixpkgs/issues/86054
      src = ./fix-qttranslations-path.patch;
      inherit qttranslations;
    })
  ];

  nativeBuildInputs = [ cmake extra-cmake-modules qttools wrapQtAppsHook ];

  buildInputs = [ leptonica tesseract4 qtmultimedia qtx11extras ];

  postInstall = ''
    substituteInPlace $out/share/applications/io.crow_translate.CrowTranslate.desktop \
      --replace "Exec=qdbus" "Exec=${lib.getBin qttools}/bin/qdbus"
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "A simple and lightweight translator that allows to translate and speak text using Google, Yandex and Bing";
    homepage = "https://crow-translate.github.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
}
