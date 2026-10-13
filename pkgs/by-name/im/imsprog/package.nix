{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  makeWrapper,
  pkg-config,

  bash,
  libftdi1,
  libusb1,
  qt6,
  wget,
  zenity,
}:

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "imsprog";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "bigbigmdm";
    repo = "IMSProg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K7biDYnWl4wbQ2t69x5X7/Cz/bWUvWlDeDOeNKrjCTg=";
  };

  env.LC_ALL = "C.UTF-8";

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    qt6.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    bash # for patching the shebang in bin/IMSProg_database_update
    libftdi1
    libusb1
    qt6.qtbase
    qt6.qtwayland
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

  postFixup = ''
    wrapProgram $out/bin/IMSProg_database_update \
      --prefix PATH : "${
        lib.makeBinPath [
          wget
          zenity
        ]
      }"
  '';

  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/bigbigmdm/IMSProg/releases/tag/v${finalAttrs.version}";
    description = "Free I2C, MicroWire and SPI EEPROM/Flash chip programmer tool for CH341A device";
    homepage = "https://github.com/bigbigmdm/IMSProg";
    license = with lib.licenses; [
      gpl3Plus
      gpl2Plus
      lgpl21Only
    ];
    mainProgram = "IMSProg";
    maintainers = with lib.maintainers; [ wucke13 ];
    platforms = lib.platforms.unix;
  };
})
