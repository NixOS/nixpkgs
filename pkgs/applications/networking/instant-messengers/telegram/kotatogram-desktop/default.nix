{ mkDerivation, lib, fetchFromGitHub, pkg-config, python3, cmake, ninja
, qtbase, qtimageformats, enchant, xdg_utils, ffmpeg, openalSoft, lzma
, lz4, xxHash, zlib, minizip, openssl, libtgvoip, range-v3
}:

with lib;

mkDerivation rec {
  pname = "kotatogram-desktop";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "kotatogram";
    repo = "kotatogram-desktop";
    rev = "k${version}";
    sha256 = "1j5wn3k1mr2c39szmyzm0pf720jmbllcaj40p2ydx0p3lir1s760";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace Telegram/lib_spellcheck/spellcheck/platform/linux/linux_enchant.cpp \
      --replace '"libenchant-2.so.2"' '"${enchant}/lib/libenchant-2.so.2"'
  '';

  nativeBuildInputs = [ pkg-config python3 cmake ninja ];

  buildInputs = [
    qtbase qtimageformats ffmpeg openalSoft lzma lz4 xxHash
    zlib minizip openssl enchant libtgvoip range-v3
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${xdg_utils}/bin"
  ];

  cmakeFlags = [
    "-DTDESKTOP_API_TEST=ON"
    "-DTDESKTOP_DISABLE_GTK_INTEGRATION=ON"
    "-DDESKTOP_APP_USE_PACKAGED_RLOTTIE=OFF"
  ];

  meta = {
    description = "Kotatogram – experimental Telegram Desktop fork";
    longDescription = ''
      Unofficial desktop client for the Telegram messenger, based on Telegram Desktop.

      It contains some useful (or purely cosmetic) features, but they could be unstable. A detailed list is available here: https://kotatogram.github.io/changes
    '';
    license = licenses.gpl3;
    platforms = platforms.linux;
    homepage = https://kotatogram.github.io;
    maintainers = with maintainers; [ ilya-fedin ];
  };
}
