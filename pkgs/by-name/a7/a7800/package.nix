{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  SDL2,
  SDL2_ttf,
  expat,
  flac,
  fontconfig,
  glm,
  libjpeg,
  libpulseaudio,
  libxi,
  libxinerama,
  libsForQt5,
  makeFontsConf,
  pkg-config,
  portaudio,
  portmidi,
  pugixml,
  python3,
  rapidjson,
  sqlite,
  utf8proc,
  versionCheckHook,
  which,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "a7800";
  version = "5.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "7800-devtools";
    repo = "a7800";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nnmT9D9mvG0YTAM432JI5komCGfHBMrNhvXBK5e+OoM=";
  };

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    pkg-config
    python3
    which
  ];

  buildInputs = [
    expat
    zlib
    flac
    portmidi
    portaudio
    utf8proc
    libjpeg
    rapidjson
    pugixml
    glm
    SDL2
    SDL2_ttf
    sqlite
    alsa-lib
    libpulseaudio
    libxinerama
    libxi
    fontconfig
    libsForQt5.qtbase
  ];

  postPatch = ''
    substituteInPlace scripts/build/msgfmt.py \
      --replace-fail ".tostring()" ".tobytes()"
    substituteInPlace 3rdparty/genie/src/tools/gcc.lua \
      --replace-fail "table.insert(result, '-rcs')" "table.insert(result, 'rcs')" \
      --replace-fail "table.insert(result, '-qc')" "table.insert(result, 'qc')" \
      --replace-fail "table.insert(result, '-cs')" "table.insert(result, 'cs')"
    substituteInPlace 3rdparty/genie/src/actions/make/make_cpp.lua \
      --replace-fail "'  LINKCMD             = \$(AR) %s \$(TARGET)'" "'  LINKCMD             = \$(AR) %s \$(TARGET) '"
    substituteInPlace 3rdparty/genie/src/host/scripts.c \
      --replace-fail "table.insert(result, '-rcs')" "table.insert(result, 'rcs')" \
      --replace-fail "table.insert(result, '-qc')" "table.insert(result, 'qc')" \
      --replace-fail "table.insert(result, '-cs')" "table.insert(result, 'cs')" \
      --replace-fail "'  LINKCMD             = \$(AR) %s \$(TARGET)'" "'  LINKCMD             = \$(AR) %s \$(TARGET) '"
    substituteInPlace 3rdparty/sol2/sol/stack_push.hpp \
      --replace-fail "return stack::push<const wchar_t*>(L, str, str + sz);" "return pusher<const wchar_t*>{}.push(L, str, str + sz);" \
      --replace-fail "return stack::push<const char16_t*>(L, str, str + sz);" "return pusher<const char16_t*>{}.push(L, str, str + sz);" \
      --replace-fail "return stack::push<const char32_t*>(L, str, str + sz);" "return pusher<const char32_t*>{}.push(L, str, str + sz);"
    substituteInPlace src/osd/modules/render/bgfx/effect.h \
      --replace-fail "#include <map>" "#include <map>"$'\n'"#include <string>"
    substituteInPlace \
      src/devices/cpu/m6809/m6809make.py \
      src/devices/cpu/m6502/m6502make.py \
      src/devices/cpu/tms57002/tmsmake.py \
      src/devices/cpu/mcs96/mcs96make.py \
      --replace-fail '"rU"' '"r"'
    substituteInPlace src/emu/emuopts.cpp \
      --replace-fail '{ OPTION_HASHPATH ";hash_directory;hash",            "hash",      OPTION_STRING,     "path to hash files" },' \
                     '{ OPTION_HASHPATH ";hash_directory;hash",            "hash;'"$out"'/opt/a7800/hash",      OPTION_STRING,     "path to hash files" },' \
      --replace-fail '{ OPTION_SAMPLEPATH ";sp",                           "samples",   OPTION_STRING,     "path to samplesets" },' \
                     '{ OPTION_SAMPLEPATH ";sp",                           "samples;'"$out"'/opt/a7800/samples",   OPTION_STRING,     "path to samplesets" },' \
      --replace-fail '{ OPTION_ARTPATH,                                    "artwork",   OPTION_STRING,     "path to artwork files" },' \
                     '{ OPTION_ARTPATH,                                    "artwork;'"$out"'/opt/a7800/artwork",   OPTION_STRING,     "path to artwork files" },' \
      --replace-fail '{ OPTION_CTRLRPATH,                                  "ctrlr",     OPTION_STRING,     "path to controller definitions" },' \
                     '{ OPTION_CTRLRPATH,                                  "ctrlr;'"$out"'/opt/a7800/ctrlr",     OPTION_STRING,     "path to controller definitions" },' \
      --replace-fail '{ OPTION_INIPATH,                                    ".;ini;ini/presets",     OPTION_STRING,     "path to ini files" },' \
                     '{ OPTION_INIPATH,                                    ".;ini;ini/presets;'"$out"'/opt/a7800/ini/presets",     OPTION_STRING,     "path to ini files" },' \
      --replace-fail '{ OPTION_FONTPATH,                                   ".",         OPTION_STRING,     "path to font files" },' \
                     '{ OPTION_FONTPATH,                                   ".;'"$out"'/opt/a7800",         OPTION_STRING,     "path to font files" },' \
      --replace-fail '{ OPTION_PLUGINSPATH,                                "plugins",   OPTION_STRING,     "path to plugin files" },' \
                     '{ OPTION_PLUGINSPATH,                                "plugins;'"$out"'/opt/a7800/plugins",   OPTION_STRING,     "path to plugin files" },' \
      --replace-fail '{ OPTION_LANGUAGEPATH,                               "language",  OPTION_STRING,     "path to language files" },' \
                     '{ OPTION_LANGUAGEPATH,                               "language;'"$out"'/opt/a7800/language",  OPTION_STRING,     "path to language files" },'
    substituteInPlace src/osd/modules/lib/osdobj_common.cpp \
      --replace-fail '{ OSDOPTION_BGFX_PATH,                    "bgfx",            OPTION_STRING, "path to BGFX-related files" },' \
                     '{ OSDOPTION_BGFX_PATH,                    "'"$out"'/opt/a7800/bgfx",            OPTION_STRING, "path to BGFX-related files" },'
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
    "USE_LIBSDL=1"
    "USE_SYSTEM_LIB_EXPAT=1"
    "USE_SYSTEM_LIB_FLAC=1"
    "USE_SYSTEM_LIB_GLM=1"
    "USE_SYSTEM_LIB_JPEG=1"
    "USE_SYSTEM_LIB_PORTAUDIO=1"
    "USE_SYSTEM_LIB_PORTMIDI=1"
    "USE_SYSTEM_LIB_PUGIXML=1"
    "USE_SYSTEM_LIB_RAPIDJSON=1"
    "USE_SYSTEM_LIB_UTF8PROC=1"
    "USE_SYSTEM_LIB_SQLITE3=1"
    "USE_SYSTEM_LIB_ZLIB=1"
  ];

  enableParallelBuilding = true;

  env.FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  preVersionCheck = ''
    export HOME=$(mktemp -d)
    export XDG_CACHE_HOME=$HOME/.cache
  '';
  versionCheckKeepEnvironment = [
    "FONTCONFIG_FILE"
    "HOME"
    "XDG_CACHE_HOME"
  ];
  versionCheckProgramArg = "-help";

  installPhase = ''
    runHook preInstall

    install -Dm755 mame64 $out/bin/a7800
    mkdir -p $out/opt/a7800
    cp -ar artwork bgfx hash ini keymaps language plugins samples uismall.bdf $out/opt/a7800/

    runHook postInstall
  '';

  meta = {
    description = "Atari 7800 emulator forked from MAME's Atari 7800 driver";
    homepage = "https://github.com/7800-devtools/a7800";
    license = with lib.licenses; [
      bsd3
      gpl2Plus
    ];
    mainProgram = "a7800";
    maintainers = with lib.maintainers; [ kaistarkk ];
    platforms = lib.platforms.linux;
  };
})
