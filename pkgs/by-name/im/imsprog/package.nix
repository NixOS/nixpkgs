{ stdenv
, lib
, fetchFromGitHub
, cmake
, libsForQt5
, libusb1
, pkg-config
, makeWrapper
, gnome
, wget
, bash
}:

stdenv.mkDerivation rec {
  pname = "imsprog";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "bigbigmdm";
    repo = "IMSProg";
    rev = "refs/tags/v${version}";
    hash = "sha256-serRHyxYp+HV1h/MtEn8LOD8DkmfOb3vR5Mcypaq6RM=";
  };

  postPatch = ''
    substituteInPlace IMSProg_programmer/CMakeLists.txt \
      --replace-fail "set(UDEVDIR \"/usr/lib/udev\")" "" \
      --replace-fail "''${UDEVDIR}/rules.d" "$out/lib/udev/rules.d"

    substituteInPlace IMSProg_programmer/other/99-CH341.rules \
      --replace-fail 'MODE="0660", GROUP="plugdev", TAG+="uaccess"' 'MODE="0666"'

    substituteInPlace IMSProg_editor/ezp_chip_editor.cpp \
      --replace-fail "/usr/share/imsprog/IMSProg.Dat" "$out/share/imsprog/IMSProg.Dat"

    substituteInPlace IMSProg_programmer/mainwindow.cpp \
      --replace-fail "/usr/share/imsprog/IMSProg.Dat" "$out/share/imsprog/IMSProg.Dat"

    substituteInPlace IMSProg_editor/main.cpp \
      --replace-fail "/usr/share/imsprog/" "$out/share/imsprog/"

    substituteInPlace IMSProg_programmer/main.cpp \
      --replace-fail "/usr/share/imsprog/" "$out/share/imsprog/"

    substituteInPlace IMSProg_editor/other/IMSProg_editor.desktop \
      --replace-fail "Exec=/usr/bin/IMSProg_editor" "Exec=$out/bin/IMSProg_editor" \
      --replace-fail "Icon=/usr/share/pixmaps/chipEdit64.png" "Icon=$out/share/pixmaps/chipEdit64.png" \
      --replace-fail "Path=/usr/bin/" "Path=$out/bin/"

    substituteInPlace IMSProg_programmer/other/IMSProg_database_update.desktop \
      --replace-fail "Exec=/usr/bin/IMSProg_database_update" "Exec=$out/bin/IMSProg_database_update" \
      --replace-fail "Icon=/usr/share/pixmaps/IMSProg_database_update.png" "Icon=$out/share/pixmaps/IMSProg_database_update.png" \
      --replace-fail "Path=/usr/bin/" "Path=$out/bin/"

    substituteInPlace IMSProg_programmer/other/IMSProg.desktop \
      --replace-fail "Exec=/usr/bin/IMSProg" "Exec=$out/bin/IMSProg" \
      --replace-fail "Icon=/usr/share/pixmaps/IMSProg64.png" "Icon=$out/share/pixmaps/IMSProg64.png" \
      --replace-fail "Path=/usr/bin/" "Path=$out/bin/"
  '';

  nativeBuildInputs = [ cmake pkg-config makeWrapper libsForQt5.wrapQtAppsHook ];

  buildInputs = [ libusb1 bash libsForQt5.qtbase ];

  strictDeps = true;

  postFixup = ''
    wrapProgram $out/bin/IMSProg_database_update \
      --prefix PATH : ${lib.makeBinPath [ gnome.zenity wget ]}
  '';

  meta = with lib; {
    changelog = "https://github.com/bigbigmdm/IMSProg?tab=readme-ov-file#revision-history";
    description = "Program to read, write EEPROM chips use the CH341A programmer device";
    homepage = "https://github.com/bigbigmdm/IMSProg";
    license = licenses.gpl3Plus;
    mainProgram = "IMSProg";
    maintainers = with maintainers; [ sund3RRR ];
    platforms = lib.platforms.linux;
  };
}
