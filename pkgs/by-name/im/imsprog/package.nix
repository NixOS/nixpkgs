{ lib, stdenv, fetchFromGitHub, cmake, makeWrapper, pkg-config, bash, gnome, libusb1, qt5, wget }:

stdenv.mkDerivation (finalAttrs: {
  pname = "imsprog";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "bigbigmdm";
    repo = "IMSProg";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-eF6TGlFEnMgMw1i/sfuXIRzNySVZe7UTKVHSIqJ+cUs=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    qt5.wrapQtAppsHook
    qt5.qttools
  ];

  buildInputs = [
    bash # for patching the shebang in bin/IMSProg_database_update
    libusb1
    qt5.qtbase
    qt5.qtwayland
  ];

  # change default hardcoded path for chip database file, udev rules et al
  postPatch = ''
    while IFS= read -r -d "" file ; do
      substituteInPlace "$file" \
        --replace-quiet '/usr/bin/' "$out/bin/" \
        --replace-quiet '/usr/lib/' "$out/lib/" \
        --replace-quiet '/usr/share/' "$out/share/"
    done < <(grep --files-with-matches --null --recursive '/usr/' .)
  '';

  preFixup = ''
    wrapProgram $out/bin/IMSProg_database_update \
      --prefix PATH : "${lib.makeBinPath [ gnome.zenity wget ]}"
  '';

  meta = with lib; {
    changelog = "https://github.com/bigbigmdm/IMSProg/releases/tag/v${version}";
    description = "A free I2C EEPROM programmer tool for CH341A device";
    homepage = "https://github.com/bigbigmdm/IMSProg";
    license = with licenses; [ gpl3Plus gpl2Plus lgpl21Only ];
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.unix;
  };
})
