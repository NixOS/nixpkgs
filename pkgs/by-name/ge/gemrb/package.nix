{
  lib,
  stdenv,
  runCommand,
  fetchFromGitHub,
  cmake,
  pkg-config,
  imagemagick,
  gtest,
  SDL2,
  SDL2_mixer,
  freetype,
  libGL,
  libiconv,
  libpng,
  libvlc,
  libvorbis,
  libX11,
  openal,
  python3,
  zlib,
  # the GLES backend on rpi is untested as I don't have the hardware
  backend ? if stdenv.hostPlatform.isx86 then "OpenGL" else "GLES",
}:

# Previously we only used libvlc *on* darwin, which is incorrect. According to
# https://github.com/gemrb/gemrb/blob/master/INSTALL it is needed for some mac versions of some
# games but there is obviously nothing wrong using those on linux.
# Additionally, when gemrb adds support for the EE games, libvlc will be needed anyway.

let
  version = "0.9.4";

  src = fetchFromGitHub {
    owner = "gemrb";
    repo = "gemrb";
    rev = "v${version}";
    hash = "sha256-+aPnOJQGRblqcrblVU5ZwA8CZqeT19rxEtn3GLuofYU=";
  };

  icons = runCommand "gemrb-icons" { nativeBuildInputs = [ imagemagick ]; } ''
    for s in 48 64 96 128 256 512 1024; do
      size=''${s}x''${s}
      dir=$out/share/icons/hicolor/$size
      mkdir -p $dir
      magick -background none -size $size ${src}/artwork/logo04-rb_only.svg -format png $dir/gemrb.png
    done
  '';

in
stdenv.mkDerivation (finalAttrs: {
  pname = "gemrb";
  inherit version src;

  buildInputs = [
    SDL2
    SDL2_mixer
    freetype
    libGL
    libiconv
    libpng
    libvlc
    libvorbis
    libX11
    openal
    python3
    zlib
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals (finalAttrs.finalPackage.doCheck or false) [ gtest ];

  cmakeFlags = [
    (lib.cmakeFeature "DATA_DIR" "${placeholder "out"}/share/gemrb")
    (lib.cmakeFeature "EXAMPLE_CONF_DIR" "${placeholder "out"}/share/doc/gemrb/examples")
    (lib.cmakeFeature "SYSCONF_DIR" "/etc")
    # use the Mesa drivers for video on ARM (harmless on x86)
    (lib.cmakeBool "DISABLE_VIDEOCORE" true)
    (lib.cmakeFeature "LAYOUT" "opt")
    (lib.cmakeFeature "OPENGL_BACKEND" backend)
    (lib.cmakeFeature "OpenGL_GL_PREFERENCE" "GLVND")
    (lib.cmakeBool "USE_TESTS" (finalAttrs.finalPackage.doCheck or false))
  ];

  postInstall = ''
    cp -r ${icons}/share/icons $out/share/
  '';

  # a bunch of tests fail in our sandbox
  doCheck = false;

  meta = with lib; {
    description = "Reimplementation of the Infinity Engine, used by games such as Baldur's Gate";
    longDescription = ''
      GemRB (Game engine made with pre-Rendered Background) is a portable
      open-source implementation of Bioware's Infinity Engine. It was written to
      support pseudo-3D role playing games based on the Dungeons & Dragons
      ruleset (Baldur's Gate and Icewind Dale series, Planescape: Torment).
    '';
    homepage = "https://gemrb.org/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    mainProgram = "gemrb";
  };
})
