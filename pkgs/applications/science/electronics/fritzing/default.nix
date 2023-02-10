{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, wrapQtAppsHook
, qmake
, pkg-config
, qtbase
, qtsvg
, qttools
, qtserialport
, boost
, libngspice
, libgit2
, quazip
}:

let
  # SHA256 of the fritzing-parts HEAD on the master branch,
  # which contains the latest stable parts definitions
  partsSha = "4713511c894cb2894eae505b9307c6555afcc32c";

  parts = fetchFromGitHub {
    owner = "fritzing";
    repo = "fritzing-parts";
    rev = partsSha;
    sha256 = "sha256-QiOGWc+99MJhOVrXyNOinR8rTVvW/E+wPfoB6QvbhY0=";
  };
in

stdenv.mkDerivation rec {
  pname = "fritzing";
  version = "unstable-2022-07-01";

  src = fetchFromGitHub {
    owner = pname;
    repo = "fritzing-app";
    rev = "40d23c29b0463d5c968c3c4b34ed5ffc05c5a258";
    sha256 = "sha256-smvfuxQWF/LMFFXHOKb3zUZsEet/XoiaxXOR5QMaYzw=";
  };

  buildInputs = [ qtbase qtsvg qtserialport boost libgit2 quazip libngspice ];
  nativeBuildInputs = [ qmake pkg-config qttools wrapQtAppsHook ];

  patches = [
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-Quick-Dirty-patch-to-allow-finding-quazip-qt5-on-Arc.patch?h=fritzing&id=1ae0dc88464f375a54b156e6761315bcb04bcc1f";
      sha256 = "sha256-iS18EWw920gyeXDoHBRGwXvwMJurJS21H77Erl+fqog=";
    })
  ];

  postPatch = ''
    substituteInPlace phoenix.pro \
      --replace 'LIBGIT_STATIC = true' 'LIBGIT_STATIC = false'

    #TODO: Do not hardcode SHA.
    substituteInPlace src/fapplication.cpp \
      --replace 'PartsChecker::getSha(dir.absolutePath());' '"${partsSha}";'

    mkdir parts
    cp -a ${parts}/* parts/
  '';

  NIX_CFLAGS_COMPILE = "-I${lib.getDev quazip}/include/QuaZip-Qt${lib.versions.major qtbase.version}-${quazip.version}/quazip";

  qmakeFlags = [
    "phoenix.pro"
  ];

  postFixup = ''
    # generate the parts.db file
    QT_QPA_PLATFORM=offscreen "$out/bin/Fritzing" \
      -db "$out/share/fritzing/parts/parts.db" \
      -pp "$out/share/fritzing/parts" \
      -folder "$out/share/fritzing"
  '';

  meta = with lib; {
    description = "An open source prototyping tool for Arduino-based projects";
    homepage = "https://fritzing.org/";
    license = with licenses; [ gpl3 cc-by-sa-30 ];
    maintainers = with maintainers; [ robberer muscaln ];
    platforms = platforms.linux;
  };
}
