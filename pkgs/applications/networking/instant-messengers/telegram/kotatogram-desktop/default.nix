{ mkDerivation, lib, fetchFromGitHub, pkg-config, python3, cmake, ninja
, qtbase, qtimageformats, libdbusmenu, hunspell, xdg-utils, ffmpeg_3, openalSoft
, lzma, lz4, xxHash, zlib, minizip, openssl, libtgvoip, tl-expected
, range-v3, libopus, alsaLib, libpulseaudio
}:

with lib;

mkDerivation rec {
  pname = "kotatogram-desktop";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "kotatogram";
    repo = "kotatogram-desktop";
    rev = "k${version}";
    sha256 = "sha256-BSVz8aXy2UdNvlkG8dfXyNlA1K2UUMfV95LdS2GJYn0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkg-config python3 cmake ninja ];

  buildInputs = [
    qtbase qtimageformats ffmpeg_3 openalSoft lzma lz4 xxHash libdbusmenu
    zlib minizip openssl hunspell libtgvoip tl-expected range-v3
    libopus alsaLib libpulseaudio
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${xdg-utils}/bin"
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DTDESKTOP_API_TEST=ON"
    "-DDESKTOP_APP_USE_PACKAGED_GSL=OFF"
    "-DDESKTOP_APP_USE_PACKAGED_RLOTTIE=OFF"
    "-DDESKTOP_APP_USE_PACKAGED_VARIANT=OFF"
    "-DTDESKTOP_USE_PACKAGED_TGVOIP=OFF"
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
