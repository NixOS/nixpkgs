{ lib
, config
, stdenv
, fetchFromGitHub
, fetchurl
, meson
, ninja
, cmake
, pkg-config
, luajit
, gettext
, python3
, wrapGAppsHook
, fontconfig
, libass
, boost
, wxGTK32
, icu
, ffms
, fftw
, libuchardet
, ffmpeg_4
, jansson
, libGL
, zlib
, libX11
, spellcheckSupport ? true
, hunspell ? null
, openalSupport ? false
, openal ? null
, alsaSupport ? stdenv.isLinux
, alsa-lib ? null
, pulseaudioSupport ? config.pulseaudio or stdenv.isLinux
, libpulseaudio ? null
, portaudioSupport ? false
, portaudio ? null
,
}:
assert spellcheckSupport -> (hunspell != null);
assert openalSupport -> (openal != null);
assert alsaSupport -> (alsa-lib != null);
assert pulseaudioSupport -> (libpulseaudio != null);
assert portaudioSupport -> (portaudio != null); let
  inherit (lib) optional;

  luajit52 = luajit.override { enable52Compat = true; };

  full_version = "feature_11";

  bestsource = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "bestsource";
    rev = "ba1249c1f5443be6d0ec2be32490af5bbc96bf99";
    hash = "sha256-9BnyRzF33otju3W503O18JuTyvp+hFxk6JMwrozKoZY=";
    fetchSubmodules = true;
  };

  vapoursynth = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "vapoursynth";
    rev = "R65";
    hash = "sha256-6w7GSC5ZNIhLpulni4sKq0OvuxHlTJRilBFGH5PQW8U=";
  };

  AviSynthPlus = fetchFromGitHub {
    owner = "AviSynth";
    repo = "AviSynthPlus";
    rev = "v3.7.3";
    hash = "sha256-sBxZ2J5sS/2wrL+tSxVAFPKNbg3c1iMSHRueRQAs5J4=";
    fetchSubmodules = true;
  };

  gtest = fetchurl {
    url = "https://github.com/google/googletest/archive/release-1.8.1.zip";
    hash = "sha256-kngnwYPQFzTMXP74Xg/z9akv/mGI4NGOkJxe/r8ooMc=";
  };

  gtest_patch = fetchurl {
    url = "https://wrapdb.mesonbuild.com/v1/projects/gtest/1.8.1/1/get_zip";
    hash = "sha256-959f1G4JUHs/LgmlHqbrIAIO/+VDM19a7lnzDMjRWAU=";
  };
in
stdenv.mkDerivation rec {
  pname = "aegisub";
  version = full_version;

  src = fetchFromGitHub {
    owner = "arch1t3cht";
    repo = "Aegisub";
    rev = full_version;
    hash = "sha256-yEXDwne+wros0WjOwQbvMIXk0UXV5TOoV/72K12vi/c=";
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    luajit52
    gettext
    python3
  ];

  buildInputs =
    [
      fontconfig
      libass
      boost
      wxGTK32
      icu
      ffms
      fftw
      libuchardet
      ffmpeg_4
      jansson
      libGL
      zlib
      libX11
    ]
    ++ optional alsaSupport alsa-lib
    ++ optional openalSupport openal
    ++ optional portaudioSupport portaudio
    ++ optional pulseaudioSupport libpulseaudio
    ++ optional spellcheckSupport hunspell;

  env = {
    BOOST_INCLUDEDIR = "${lib.getDev boost}/include";
    BOOST_LIBRARYDIR = "${lib.getLib boost}/lib";
    NIX_CFLAGS_COMPILE = "-I${luajit52}/include";
    NIX_CFLAGS_LINK = "-L${luajit52}/lib";
  };

  patches = [
    # https://aur.archlinux.org/cgit/aur.git/tree/0001-bas-to-bs.patch?h=aegisub-arch1t3cht
    ./0001-bas-to-bs.patch
    # Fix git_version.h unable to generate
    ./0002-remove-git-version.patch
    # Fix meson unable exec python respack
    # https://github.com/arch1t3cht/Aegisub/pull/121
    ./0003-respack-unable-run.patch
  ];

  mesonFlags =
    [
      "--buildtype=release"
      (lib.mesonBool "b_lto" false)
      (lib.mesonOption "default_audio_output" "auto")
      (lib.mesonEnable "directsound" false)
      (lib.mesonEnable "xaudio2" false)

      (lib.mesonEnable "ffms2" true)
      (lib.mesonEnable "avisynth" true)
      (lib.mesonEnable "bestsource" true)
      (lib.mesonEnable "vapoursynth" true)

      (lib.mesonEnable "fftw3" true)
      (lib.mesonEnable "uchardet" true)
      (lib.mesonEnable "csri" true)
    ]
    ++ (
      if alsaSupport
      then [ (lib.mesonEnable "alsa" true) ]
      else [ (lib.mesonEnable "alsa" false) ]
    )
    ++ (
      if openalSupport
      then [ (lib.mesonEnable "openal" true) ]
      else [ (lib.mesonEnable "openal" false) ]
    )
    ++ (
      if pulseaudioSupport
      then [ (lib.mesonEnable "libpulse" true) (lib.mesonOption "default_audio_output" "PulseAudio") ]
      else [ (lib.mesonEnable "libpulse" false) ]
    )
    ++ (
      if portaudioSupport
      then [ (lib.mesonEnable "portaudio" true) ]
      else [ (lib.mesonEnable "portaudio" false) ]
    )
    ++ (
      if spellcheckSupport
      then [ (lib.mesonEnable "hunspell" true) ]
      else [ (lib.mesonEnable "hunspell" false) ]
    );

  enableParallelBuilding = true;

  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/video/aegisub/default.nix
  # https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=aegisub-arch1t3cht
  preConfigure = ''
    cp -r --no-preserve=mode ${bestsource} subprojects/bestsource
    cp -r --no-preserve=mode ${AviSynthPlus} subprojects/avisynth
    cp -r --no-preserve=mode ${vapoursynth} subprojects/vapoursynth

    mkdir subprojects/packagecache
    cp -r --no-preserve=mode ${gtest} subprojects/packagecache/gtest-1.8.1.zip
    cp -r --no-preserve=mode ${gtest_patch} subprojects/packagecache/gtest-1.8.1-1-wrap.zip

    meson subprojects packagefiles --apply bestsource
    meson subprojects packagefiles --apply avisynth
    meson subprojects packagefiles --apply vapoursynth

    mkdir -p build
    echo "#define BUILD_GIT_VERSION_NUMBER 0" > build/git_version.h
    echo """#define BUILD_GIT_VERSION_STRING \"${full_version}\"""" >> build/git_version.h
  '';

  meta = with lib; {
    description = "Cross-platform advanced subtitle editor, with new feature branches.";
    homepage = "https://github.com/arch1t3cht/Aegisub";
    license = licenses.bsd3;
    mainProgram = "aegisub";
    platforms = platforms.all;
  };
}
