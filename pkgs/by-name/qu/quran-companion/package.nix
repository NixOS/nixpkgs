{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "quran-companion";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "0xzer0x";
    repo = "quran-companion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7d2KmGgujrC/aGJ0Szqw9zctlRIULoOMOkwp/FJi95A=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtmultimedia
    qt6.qttools
    qt6.qtimageformats
    qt6.qttranslations
  ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    cmake
  ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  meta = {
    description = "Free and open-source desktop Quran reader and player";
    longDescription = ''
      Quran Companion is a cross-platform Quran reader/player with
      recitation download capabilities, verse highlighting,
      resizable quran font, and a variety of tafsir books &
      translations
    '';
    homepage = "https://0xzer0x.github.io/projects/quran-companion/";
    changelog = "https://github.com/0xzer0x/quran-companion/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.free;
    mainProgram = "quran-companion";
    maintainers = with lib.maintainers; [ MostafaKhaled ];
    platforms = lib.platforms.unix;
  };
})
