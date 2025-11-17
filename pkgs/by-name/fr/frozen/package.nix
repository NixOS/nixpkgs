{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frozen";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "cesanta";
    repo = "frozen";
    tag = finalAttrs.version;
    hash = "sha256-dOQb6wVufkqOSVZa2o8A1DLad0zvo2xQzmu09J2ZT7E=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  # frozen has a simple Makefile and a GN BUILD file as building scripts.
  # Since it has only two source files, the best course of action to support
  # cross compilation is to create a small meson.build file.
  # Relevant upstream issue: https://github.com/cesanta/frozen/pull/71
  # We also remove the GN BUILD file to prevent conflicts on case-insensitive
  # file systems.
  preConfigure = ''
    rm BUILD
    cp ${./meson.build} meson.build
  '';

  meta = {
    homepage = "https://github.com/cesanta/frozen";
    description = "Minimal JSON parser for C, targeted for embedded systems";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thillux ];
    platforms = lib.platforms.unix;
  };
})
