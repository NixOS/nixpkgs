{ lib, stdenv, fetchFromGitHub, qmake, qtbase, qttools, wrapQtAppsHook, copyDesktopItems }:

let datapath = "$out/share/XaoS";
in stdenv.mkDerivation rec {
  pname = "xaos";
  version = "4.2.1";
  outputs = [ "out" "man" ];

  src = fetchFromGitHub {
    owner = "xaos-project";
    repo = pname;
    rev = "release-${version}";
    hash = "sha256-JLF8Mz/OHZEEJG/aryKQuJ6B5R8hPJdvln7mbKoqXFU=";
  };

  nativeBuildInputs = [ qmake qttools wrapQtAppsHook copyDesktopItems ];
  buildInputs = [ qtbase ];

  QMAKE_LRELEASE = "lrelease";
  DEFINES = [ "USE_OPENGL" "USE_FLOAT128" ];

  postPatch = ''
    substituteInPlace src/include/config.h \
      --replace "/usr/share/XaoS" "${datapath}"
  '';

  desktopItems = [ "xdg/xaos.desktop" ];

  installPhase = ''
    runHook preInstall

    install -D bin/xaos "$out/bin/xaos"

    mkdir -p "${datapath}"
    cp -r tutorial examples catalogs "${datapath}"

    install -D "xdg/${pname}.png" "$out/share/icons/${pname}.png"

    install -D doc/xaos.6 "$man/man6/xaos.6"
    runHook postInstall
  '';

  meta = src.meta // {
    description = "Real-time interactive fractal zoomer";
    homepage = "https://xaos-project.github.io/";
    license = lib.licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ehmry ];
  };
}
