{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libGL,
  SDL2,
  SDL2_image,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fifechan";
  # Do not bump on its own: 0.2.0+ renamed core widget classes and fifengine
  # 0.4.3 does not build against it. Both move together at fifengine 0.5.0.
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "fifengine";
    repo = "fifechan";
    tag = finalAttrs.version;
    hash = "sha256-jzmZYfB4B9CFWgZvIXsmWic8TgUW7toz2FDozNIio0E=";
  };

  postPatch = ''
    # CMake 4 dropped compatibility with < 3.5.
    substituteInPlace CMakeLists.txt \
      --replace-fail "CMAKE_MINIMUM_REQUIRED(VERSION 2.6.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    libGL # builds libfifechan_opengl, which fifengine requires
    SDL2
    SDL2_image
  ];

  __structuredAttrs = true;

  strictDeps = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "0\\.1\\..*"
    ];
  };

  meta = {
    description = "C++ GUI library designed for games, used by the FIFE engine";
    homepage = "https://fifengine.github.io/fifechan/";
    license = with lib.licenses; [
      lgpl21Plus
      bsd3
    ];
    maintainers = with lib.maintainers; [ FlorianFranzen ];
    # Upstream supports macOS, but only Linux is tested here.
    platforms = lib.platforms.linux;
  };
})
