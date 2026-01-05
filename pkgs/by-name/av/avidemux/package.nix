{
  stdenv,
  lib,
  fetchurl,
  fetchpatch,
  cmake,
  pkg-config,
  zlib,
  gettext,
  libvdpau,
  libva,
  libXv,
  sqlite,
  yasm,
  freetype,
  fontconfig,
  fribidi,
  makeWrapper,
  libXext,
  libGLU,
  alsa-lib,
  withX265 ? true,
  x265,
  withX264 ? true,
  x264,
  withXvid ? true,
  xvidcore,
  withLAME ? true,
  lame,
  withFAAC ? false,
  faac,
  withVorbis ? true,
  libvorbis,
  withPulse ? true,
  libpulseaudio,
  withFAAD ? true,
  faad2,
  withOpus ? true,
  libopus,
  withVPX ? true,
  libvpx,
  withQT ? true,
  libsForQt5,
  withCLI ? true,
  default ? "qt5",
  withPlugins ? true,
}:

assert default != "qt5" -> default == "cli";
assert !withQT -> default != "qt5";

stdenv.mkDerivation rec {
  pname = "avidemux";
  version = "2.8.1";

  src = fetchurl {
    url = "mirror://sourceforge/avidemux/avidemux/${version}/avidemux_${version}.tar.gz";
    sha256 = "sha256-d9m9yoaDzlfBkradIHz6t8+Sp3Wc4PY/o3tcjkKtPaI=";
  };

  patches = [
    ./dynamic_install_dir.patch
    ./bootstrap_logging.patch
    # x265 API change in 4.1 breaks build
    # See discussion in https://avidemux.org/smif/index.php/topic,19995.msg97494.html#msg97494
    (fetchpatch {
      name = "fix_build_with_x265_4_1.patch";
      url = "https://github.com/mean00/avidemux2/commit/c16d32a67cdb012db093472ad3776713939a30d1.patch";
      hash = "sha256-5QqocvYaY/phyvSX2lhTzeAi+z9Wgqs+ITR0cXReps4=";
    })
  ];

  postPatch = ''
    cp ${
      fetchpatch {
        # Backport fix for binutils-2.41.
        name = "binutils-2.41.patch";
        url = "https://git.ffmpeg.org/gitweb/ffmpeg.git/patch/effadce6c756247ea8bae32dc13bb3e6f464f0eb";
        hash = "sha256-s9PcYbt0mFb2wvgMcFL1J+2OS6Sxyd2wYkGzLr2qd9M=";
        stripLen = 1;
      }
    } avidemux_core/ffmpeg_package/patches/

    # Those CMake versions are deprecated and is no longer supported by CMake > 4
    # https://github.com/NixOS/nixpkgs/issues/445447
    substituteInPlace {avidemux_plugins,avidemux_core,avidemux/{cli,qt4}}/CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 3.0)" \
      "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace avidemux/gtk/CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.6)" \
      "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace avidemux/qt4/xdg_data/CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.8.11)" \
      "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace addons/fontGen/CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.8)" \
      "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    yasm
    cmake
    pkg-config
    makeWrapper
  ]
  ++ lib.optional withQT libsForQt5.wrapQtAppsHook;
  buildInputs = [
    zlib
    gettext
    libvdpau
    libva
    libXv
    sqlite
    fribidi
    fontconfig
    freetype
    alsa-lib
    libXext
    libGLU
  ]
  ++ lib.optional withX264 x264
  ++ lib.optional withX265 x265
  ++ lib.optional withXvid xvidcore
  ++ lib.optional withLAME lame
  ++ lib.optional withFAAC faac
  ++ lib.optional withVorbis libvorbis
  ++ lib.optional withPulse libpulseaudio
  ++ lib.optional withFAAD faad2
  ++ lib.optional withOpus libopus
  ++ lib.optionals withQT (
    with libsForQt5;
    [
      qttools
      qtbase
    ]
  )
  ++ lib.optional withVPX libvpx;

  dontWrapQtApps = true;

  buildCommand =
    let
      wrapWith =
        makeWrapper: filename:
        "${makeWrapper} ${filename} --set ADM_ROOT_DIR $out --prefix LD_LIBRARY_PATH : ${libXext}/lib";
      wrapQtApp = wrapWith "wrapQtApp";
      wrapProgram = wrapWith "wrapProgram";
    in
    ''
      unpackPhase
      cd "$sourceRoot"
      patchPhase

      ${stdenv.shell} bootStrap.bash \
        --with-core \
        ${if withQT then "--with-qt" else "--without-qt"} \
        ${if withCLI then "--with-cli" else "--without-cli"} \
        ${if withPlugins then "--with-plugins" else "--without-plugins"}

      mkdir $out
      cp -R install/usr/* $out

      ${wrapProgram "$out/bin/avidemux3_cli"}

      ${lib.optionalString withQT ''
        ${wrapQtApp "$out/bin/avidemux3_qt5"}
        ${wrapQtApp "$out/bin/avidemux3_jobs_qt5"}
      ''}

      ln -s "$out/bin/avidemux3_${default}" "$out/bin/avidemux"

      # make the install path match the rpath
      if [[ -d ''${!outputLib}/lib64 ]]; then
        mv ''${!outputLib}/lib64 ''${!outputLib}/lib
        ln -s lib ''${!outputLib}/lib64
      fi
      fixupPhase
    '';

  meta = with lib; {
    homepage = "http://fixounet.free.fr/avidemux/";
    description = "Free video editor designed for simple video editing tasks";
    maintainers = [ ];
    # "CPU not supported" errors on AArch64
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
    license = licenses.gpl2;
  };
}
