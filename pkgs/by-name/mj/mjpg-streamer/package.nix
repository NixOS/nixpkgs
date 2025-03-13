{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libjpeg,
}:

stdenv.mkDerivation {
  pname = "mjpg-streamer";
  version = "unstable-2019-05-24";

  src = fetchFromGitHub {
    owner = "jacksonliam";
    repo = "mjpg-streamer";
    rev = "501f6362c5afddcfb41055f97ae484252c85c912";
    sha256 = "1cl159svfs1zzzrd3zgn4x7qy6751bvlnxfwf5hn5fmg4iszajw7";
  };

  prePatch = ''
    cd mjpg-streamer-experimental
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libjpeg ];

  postFixup = ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/mjpg_streamer):$out/lib/mjpg-streamer" $out/bin/mjpg_streamer
  '';

  meta = with lib; {
    homepage = "https://github.com/jacksonliam/mjpg-streamer";
    description = "Takes JPGs from Linux-UVC compatible webcams, filesystem or other input plugins and streams them as M-JPEG via HTTP to webbrowsers, VLC and other software";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ ];
    mainProgram = "mjpg_streamer";
  };
}
