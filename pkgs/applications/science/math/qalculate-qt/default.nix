{ lib, stdenv, fetchFromGitHub, intltool, pkg-config, qmake, wrapQtAppsHook, libqalculate, qtbase, qttools, qtsvg, qtwayland }:

stdenv.mkDerivation rec {
  pname = "qalculate-qt";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "qalculate-qt";
    rev = "v${version}";
    hash = "sha256-7VlaoiY+HgHCMZCegUdy2wpgfx3fKaViMtkdNRleHaA=";
  };

  nativeBuildInputs = [ qmake intltool pkg-config qttools wrapQtAppsHook ];
  buildInputs = [ libqalculate qtbase qtsvg ]
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
