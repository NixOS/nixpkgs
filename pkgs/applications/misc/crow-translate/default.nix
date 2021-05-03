{ lib
, mkDerivation
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
}:
let
  singleapplication = fetchFromGitHub {
    owner = "itay-grudev";
    repo = "SingleApplication";
    rev = "v3.2.0";
    sha256 = "0w3z97dcqcz3bf7w6fja4smkafmx9kvhzb9px4k2nfmmyxh4yfma";
  };
  qtaskbarcontrol = fetchFromGitHub {
    owner = "Skycoder42";
    repo = "QTaskbarControl";
    rev = "2.0.2";
    sha256 = "0iymcvq3pv07fs9l4kh6hi1igqr7957iqndhsmg9fqkalf8nqyad";
  };
  qhotkey = fetchFromGitHub {
    owner = "Skycoder42";
    repo = "QHotkey";
    rev = "1.4.2";
    sha256 = "0391fkqrxqmzpvms4rk06aq05l308k6sadp6y3czq0gx2kng8mn9";
  };
  qonlinetranslator = fetchFromGitHub {
    owner = "crow-translate";
    repo = "QOnlineTranslator";
    rev = "1.4.1";
    sha256 = "1c6a8mdxms5vh8l7shi2kqdhafbzm50pbz6g1hhgg6qslla0vfn0";
  };
  circleflags = fetchFromGitHub {
    owner = "HatScripts";
    repo = "circle-flags";
    rev = "v2.0.0";
    sha256 = "1xz5b6nhcxxzalcgwnw36npap71i70s50g6b63avjgjkwz1ys5j4";
  };
in
mkDerivation rec {
  pname = "crow-translate";
  version = "2.8.1";

  src = fetchFromGitHub {
    owner = "crow-translate";
    repo = "crow-translate";
    rev = version;
    sha256 = "sha256-fmlNUhNorV/MUdfdDXM6puAblTTa6p2slVT/EKy5THg=";
  };

  patches = [
    (substituteAll {
      src = ./dont-fetch-external-libs.patch;
      inherit singleapplication qtaskbarcontrol qhotkey qonlinetranslator circleflags;
    })
    (substituteAll {
      # See https://github.com/NixOS/nixpkgs/issues/86054
      src = ./fix-qttranslations-path.patch;
      inherit qttranslations;
    })
  ];

  postPatch = "cp -r ${circleflags}/flags/* data/icons";

  nativeBuildInputs = [ cmake extra-cmake-modules qttools ];

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
