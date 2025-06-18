{
  lib,
  alsa-lib,
  boost,
  meson,
  config,
  expat,
  fetchFromGitHub,
  ffmpeg,
  ffms,
  fftw,
  fontconfig,
  freetype,
  fribidi,
  harfbuzz,
  hunspell,
  icu,
  intltool,
  libGL,
  libass,
  libpulseaudio,
  libuchardet,
  luajit,
  ninja,
  openal,
  pkg-config,
  portaudio,
  python3,
  stdenv,
  vapoursynth-bestsource,
  wrapGAppsHook3,
  wxGTK32,
  zlib,
  # Boolean guard flags
  alsaSupport ? stdenv.hostPlatform.isLinux,
  openalSupport ? true,
  portaudioSupport ? true,
  pulseaudioSupport ? config.pulseaudio or stdenv.hostPlatform.isLinux,
  spellcheckSupport ? true,
  useBundledLuaJIT ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aegisub";
  version = "feature_12";

  src = fetchFromGitHub {
    owner = "arch1t3cht";
    repo = "aegisub";
    rev = finalAttrs.version;
    hash = "sha256-P+0aUeFsjke3Jj/QtGJRdaS0negYSnhiuf5QCw2Of5Q=";
  };

  nativeBuildInputs = [
    meson
    intltool
    ninja
    pkg-config
    python3
    wxGTK32
    wrapGAppsHook3
  ];

  buildInputs =
    [
      boost
      expat
      ffmpeg
      ffms
      fftw
      fontconfig
      freetype
      fribidi
      harfbuzz
      icu
      libGL
      libass
      libuchardet
      vapoursynth-bestsource
      wxGTK32
      zlib
    ]
    ++ lib.optionals alsaSupport [ alsa-lib ]
    ++ lib.optionals (openalSupport && !stdenv.hostPlatform.isDarwin) [ openal ]
    ++ lib.optionals portaudioSupport [ portaudio ]
    ++ lib.optionals pulseaudioSupport [ libpulseaudio ]
    ++ lib.optionals spellcheckSupport [ hunspell ]
    ++ lib.optionals (!useBundledLuaJIT) [ (luajit.override { enable52Compat = true; }) ];

  mesonFlags = [
    (lib.mesonEnable "alsa" alsaSupport)
    (lib.mesonEnable "openal" openalSupport)
    (lib.mesonEnable "libpulse" pulseaudioSupport)
    (lib.mesonEnable "portaudio" portaudioSupport)

    (lib.mesonEnable "avisynth" false)
    # TODO: Requires upstream changes to allow using system VapourSynth.
    (lib.mesonEnable "vapoursynth" false)

    (lib.mesonEnable "hunspell" spellcheckSupport)

    (lib.mesonBool "system_luajit" (!useBundledLuaJIT))
  ];

  hardeningDisable = [
    "bindnow"
    "relro"
  ];

  strictDeps = true;

  postPatch = ''
    patchShebangs tools/respack.py

    # TODO: Tests require wrapped GoogleTest; upstream support for
    # system version?
    substituteInPlace meson.build \
      --replace-fail "subdir('tests')" "# subdir('tests')"
  '';

  # Inject the version, per the AUR package:
  # <https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=aegisub-arch1t3cht&id=bbbea73953858fc7bf2775a0fb92cec49afb586c>
  preBuild = ''
    cat > git_version.h <<EOF
    #define BUILD_GIT_VERSION_NUMBER 0
    #define BUILD_GIT_VERSION_STRING "${finalAttrs.version}"
    EOF
  '';

  meta = {
    homepage = "https://github.com/arch1t3cht/Aegisub";
    description = "Advanced subtitle editor; arch1t3cht's fork";
    longDescription = ''
      Aegisub is a free, cross-platform open source tool for creating and
      modifying subtitles. Aegisub makes it quick and easy to time subtitles to
      audio, and features many powerful tools for styling them, including a
      built-in real-time video preview.
    '';
    # The Aegisub sources are itself BSD/ISC, but they are linked against GPL'd
    # softwares - so the resulting program will be GPL
    license = with lib.licenses; [
      bsd3
    ];
    mainProgram = "aegisub";
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
    # https://github.com/arch1t3cht/Aegisub/issues/154
    badPlatforms = lib.platforms.darwin;
  };
})
