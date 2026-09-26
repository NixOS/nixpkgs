{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libjpeg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mjpg-streamer";
  version = "1.0.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jacksonliam";
    repo = "mjpg-streamer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q+B/T2Mpavxy54Z27LtaiVIGeQep5L8+XaQEJMS7AXE=";
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

  meta = {
    homepage = "https://github.com/jacksonliam/mjpg-streamer";
    description = "Takes JPGs from Linux-UVC compatible webcams, filesystem or other input plugins and streams them as M-JPEG via HTTP to webbrowsers, VLC and other software";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2;
    maintainers = [ ];
    mainProgram = "mjpg_streamer";
  };
})
