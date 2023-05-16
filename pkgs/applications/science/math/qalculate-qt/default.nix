{ lib, stdenv, fetchFromGitHub, intltool, pkg-config, qmake, wrapQtAppsHook, libqalculate, qtbase, qttools, qtsvg, qtwayland }:

stdenv.mkDerivation rec {
  pname = "qalculate-qt";
<<<<<<< HEAD
  version = "4.8.0";
=======
  version = "4.6.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-qt";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-7VlaoiY+HgHCMZCegUdy2wpgfx3fKaViMtkdNRleHaA=";
  };

  nativeBuildInputs = [ qmake intltool pkg-config qttools wrapQtAppsHook ];
  buildInputs = [ libqalculate qtbase qtsvg ]
=======
    hash = "sha256-9DT1U0iKj5C/Tc9MggEr/RwHhVr4GSOJQVhTiLFk9NY=";
  };

  nativeBuildInputs = [ qmake intltool pkg-config wrapQtAppsHook ];
  buildInputs = [ libqalculate qtbase qttools qtsvg ]
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    ++ lib.optionals stdenv.isLinux [ qtwayland ];

  postPatch = ''
    substituteInPlace qalculate-qt.pro\
      --replace "LRELEASE" "${qttools.dev}/bin/lrelease"
  '';

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/qalculate-qt.app $out/Applications
    makeWrapper $out/{Applications/qalculate-qt.app/Contents/MacOS,bin}/qalculate-qt
  '';

  meta = with lib; {
    description = "The ultimate desktop calculator";
    homepage = "http://qalculate.github.io";
    maintainers = with maintainers; [ _4825764518 ];
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
