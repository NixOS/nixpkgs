{ mkDerivation, lib, fetchFromGitHub, pkg-config, python3, cmake, ninja
, qtbase, qtimageformats, libsForQt5, hunspell, xdg_utils, ffmpeg_3, openalSoft
, lzma, lz4, xxHash, zlib, minizip, openssl, libtgvoip, microsoft_gsl, tl-expected
, range-v3
}:

with lib;

mkDerivation rec {
  pname = "kotatogram-desktop";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "kotatogram";
    repo = "kotatogram-desktop";
    rev = "k${version}";
    sha256 = "00pdx3cjhrihf7ihhmszcf159jrzn1bcx20vwiiizs5r1qk8l210";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config python3 cmake ninja ];

  buildInputs = [
    qtbase qtimageformats ffmpeg_3 openalSoft lzma lz4 xxHash libsForQt5.libdbusmenu
    zlib minizip openssl hunspell libtgvoip microsoft_gsl tl-expected range-v3
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${xdg_utils}/bin"
  ];

  cmakeFlags = [
    "-DTDESKTOP_API_TEST=ON"
    "-DDESKTOP_APP_USE_PACKAGED_RLOTTIE=OFF"
    "-DDESKTOP_APP_USE_PACKAGED_VARIANT=OFF"
  ];

  meta = {
    description = "Kotatogram – experimental Telegram Desktop fork";
    longDescription = ''
      Unofficial desktop client for the Telegram messenger, based on Telegram Desktop.

      It contains some useful (or purely cosmetic) features, but they could be unstable. A detailed list is available here: https://kotatogram.github.io/changes
    '';
    license = licenses.gpl3;
    platforms = platforms.linux;
    homepage = "https://kotatogram.github.io";
    maintainers = with maintainers; [ ilya-fedin ];
  };
}
