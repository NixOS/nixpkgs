{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  libxrandr,
  libGL,
}:

buildNimPackage (finalAttrs: {
  name = "boomer";
  pname = "boomer";
  version = "0-unstable-2024-02-08";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = "boomer";
    rev = "dfd4e1f5514e2a9d7c7a6429c1c0642c2021e792";
    hash = "sha256-o65/VVxttriA5Qqt35lLKkWIZYS7T4VBBuYdAIGUmx8=";
  };

  lockFile = ./lock.json;

  postFixup = ''
    existing=$(patchelf --print-rpath $out/bin/boomer)
    patchelf --set-rpath "$existing:${
      lib.makeLibraryPath [
        libxrandr
        libGL
      ]
    }" $out/bin/boomer
  '';

  meta = {
    description = "Zooming tool for X11 desktop";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      woynert
    ];
    mainProgram = "boomer";
    homepage = "https://github.com/tsoding/boomer";
  };
})
