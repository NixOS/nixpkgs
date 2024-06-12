{ fetchFromGitHub, lib, stdenv
, git, gnupg, pass, pwgen, qrencode
, qtbase, qtsvg, qttools, qmake, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "qtpass";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "IJHack";
    repo = "QtPass";
    rev = "v${version}";
    sha256 = "sha256-oKLLmsuXD2Hb2LQ4tcJP2gpR6eLaM/JzDhRcRSpUPYI=";
  };

  postPatch = ''
    substituteInPlace src/qtpass.cpp \
      --replace "/usr/bin/qrencode" "${qrencode}/bin/qrencode"
  '';

  buildInputs = [ git gnupg pass qtbase qtsvg ];

  nativeBuildInputs = [ qmake qttools wrapQtAppsHook ];

  qmakeFlags = [
    # setup hook only sets QMAKE_LRELEASE, set QMAKE_LUPDATE too:
    "QMAKE_LUPDATE=${qttools.dev}/bin/lupdate"
  ];

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ git gnupg pass pwgen ]}"
  ];

  postInstall = ''
    install -D qtpass.desktop -t $out/share/applications
    install -D artwork/icon.svg $out/share/icons/hicolor/scalable/apps/qtpass-icon.svg
    install -D qtpass.1 -t $out/share/man/man1
  '';

  meta = with lib; {
    description = "Multi-platform GUI for pass, the standard unix password manager";
    mainProgram = "qtpass";
    homepage = "https://qtpass.org";
    license = licenses.gpl3;
    maintainers = [ maintainers.hrdinka ];
    platforms = platforms.all;
  };
}
