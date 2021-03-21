{ lib
, mkDerivation
, fetchFromGitLab
, cmake
, extra-cmake-modules
, kcoreaddons
, kdeclarative
, ki18n
, kirigami2
, mpv
, qtmultimedia
, qtquickcontrols2
, youtube-dl
}:

mkDerivation rec {
  pname = "plasmatube";
  version = "unstable-2021-03-18";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "lnj";
    repo = "plasmatube";
    rev = "48dd9056326f512c2b67a2d7faecb7c02b1fe253";
    sha256 = "14p623ra2m5n1r4aly5nlrd7qbb85ycnjf1mzb9mspm8r22nlv4g";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kcoreaddons
    kdeclarative
    ki18n
    kirigami2
    mpv
    qtmultimedia
    qtquickcontrols2
  ];

  qtWrapperArgs = [
    "--prefix" "PATH" ":" (lib.makeBinPath [ youtube-dl ])
  ];

  meta = with lib; {
    description = "Kirigami YouTube video player based on libmpv and youtube-dl";
    homepage = "https://invent.kde.org/lnj/plasmatube";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
