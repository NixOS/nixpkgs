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
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "TypesettingTools";
    repo = "aegisub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ho+JG570FWbiYZ86CbCKa52j6UNyPIUh8fxpM3vVU/M=";
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

  buildInputs = [
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
    wxGTK32
    zlib
  ]
  ++ lib.optionals alsaSupport [ alsa-lib ]
  ++ lib.optionals (openalSupport && !stdenv.hostPlatform.isDarwin) [ openal ]
  ++ lib.optionals portaudioSupport [ portaudio ]
  ++ lib.optionals pulseaudioSupport [ libpulseaudio ]
  ++ lib.optionals spellcheckSupport [ hunspell ]
  ++ lib.optionals (!useBundledLuaJIT) [ luajit ];

  mesonFlags = [
    (lib.mesonEnable "alsa" alsaSupport)
    (lib.mesonEnable "openal" openalSupport)
    (lib.mesonEnable "libpulse" pulseaudioSupport)
    (lib.mesonEnable "portaudio" portaudioSupport)

    (lib.mesonEnable "avisynth" false)

    (lib.mesonEnable "hunspell" spellcheckSupport)

    (lib.mesonBool "build_osx_bundle" stdenv.hostPlatform.isDarwin)
    (lib.mesonBool "enable_update_checker" false)
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

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv Aegisub.app $out/Applications
    makeWrapper $out/Applications/Aegisub.app/Contents/MacOS/aegisub $out/bin/aegisub
  '';

  meta = {
    homepage = "https://github.com/TypesettingTools/Aegisub";
    description = "Advanced subtitle editor";
    longDescription = ''
      Aegisub is a free, cross-platform open source tool for creating and
      modifying subtitles. Aegisub makes it quick and easy to time subtitles to
      audio, and features many powerful tools for styling them, including a
      built-in real-time video preview.
    '';
    # The Aegisub sources are itself BSD/ISC, but they are linked against GPL'd
    # software - so the resulting program will be GPL
    license = with lib.licenses; [
      bsd3
    ];
    mainProgram = "aegisub";
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
  };
})
