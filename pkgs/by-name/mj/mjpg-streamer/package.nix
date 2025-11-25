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

  patches = [
    # https://patchwork.ozlabs.org/project/buildroot/patch/20240808192126.1767471-1-bernd@kuhls.net/#3373402
    # https://github.com/jacksonliam/mjpg-streamer/pull/401
    ./fix-undefined-symbol-error.patch
  ];

  prePatch = ''
    substituteInPlace ./mjpg-streamer-experimental/CMakeLists.txt --replace-fail "cmake_minimum_required(VERSION 2.8.3)" "cmake_minimum_required(VERSION 2.8.3...3.10)"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libjpeg ];

  preConfigure = ''
    cd mjpg-streamer-experimental
  '';

  postFixup = ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/mjpg_streamer):$out/lib/mjpg-streamer" $out/bin/mjpg_streamer
  '';

  meta = with lib; {
    homepage = "https://github.com/jacksonliam/mjpg-streamer";
    description = "Takes JPGs from Linux-UVC compatible webcams, filesystem or other input plugins and streams them as M-JPEG via HTTP to webbrowsers, VLC and other software";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ ];
    mainProgram = "mjpg_streamer";
  };
}
