{
  stdenv,
  lib,
  fetchFromGitHub,
  symlinkJoin,
  cairo,
  libxcb,
  libx11,
  cppcheck,
  zenity,
  nix-update-script,

  instructionSet ? "avx", # sse2 or avx
}:
let
  arch = stdenv.targetPlatform.uname.processor;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "js80p";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "attilammagyar";
    repo = "js80p";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RFaQJLk3Dj+ftRXfRizC62YtzlnR0PvbZFlBgCrUgiw=";
  };

  postPatch = ''
    substituteInPlace make/linux-gpp.mk \
      --replace-fail "/usr/bin/objcopy" "${stdenv.cc}/bin/objcopy"

    substituteInPlace src/gui/xcb.cpp \
      --replace-fail "/usr/bin/zenity" "${zenity}/bin/zenity"
  '';

  buildInputs = [
    cairo
    libx11
    libxcb
  ];

  CPP_TARGET_PLATFORM = lib.getExe' stdenv.cc "c++";

  SYS_LIB_PATH =
    let
      libraries = symlinkJoin {
        name = "js80p-libs";
        paths = [
          cairo
          libxcb
        ];
      };
    in
    "${libraries}/lib";

  VERSION_STR = "v${finalAttrs.version}";
  VERSION_INT = lib.replaceString "." "" finalAttrs.version;

  CPP_DEV_PLATFORM = lib.getExe' stdenv.cc "c++";
  CPPCHECK = lib.getExe' cppcheck "cppcheck";

  NIX_CFLAGS_COMPILE = "-Wno-format-security";

  installPhase = ''
    mkdir -p $out/share/js80p
    cp -r presets $out/share/js80p

    mkdir -p $out/share/js80p/doc
    cp README.md $out/share/js80p/doc

    pushd dist
      mkdir -p $out/lib/vst3
      install -Dm755 js80p-dev-linux-${arch}-${instructionSet}-vst3_single_file/js80p.vst3 $out/lib/vst3/js80p.so

      mkdir -p $out/lib/vst
      cp -r js80p-dev-linux-${arch}-${instructionSet}-fst/js80p.so $out/lib/vst
    popd
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "MIDI driven, performance oriented, versatile synthesizer";
    homepage = "https://attilammagyar.github.io/js80p";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.mrtnvgr ];
  };
})
