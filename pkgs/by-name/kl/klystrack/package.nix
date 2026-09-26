{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  SDL2,
  SDL2_image,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "klystrack";
  version = "1.7.6";

  src = fetchFromGitHub {
    owner = "kometbomb";
    repo = "klystrack";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-30fUI4abo4TxoUdZfKBowL4lF/lDiwnhQASr1kTVKcE=";
  };

  # https://github.com/kometbomb/klystrack/commit/6dac9eb5e75801ce4dec1d8b339f78e3df2f54bc fixes build but doesn't apply as-is, just patch in the flag
  # Make embedded date reproducible
  # Use pkg-config instead of sdl2-config
  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '-DUSESDL_IMAGE' '-DUSESDL_IMAGE -DUSESDL_RWOPS'

    substituteInPlace Makefile klystron/Makefile \
      --replace-fail 'date' 'date --date @$(SOURCE_DATE_EPOCH)'

    substituteInPlace klystron/common.mk klystron/tools/makebundle/Makefile \
      --replace-fail 'sdl2-config' 'pkg-config sdl2 SDL2_image'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/kometbomb/klystrack/commit/bb537595d02140176831c4a1b8e9121978b32d22.patch";
      hash = "sha256-sb7ZYf27qfmWp8RiZFIIOpUJenp0hNXvTAM8LgFO9Bk=";
    })
  ];

  # Workaround build failure on -fno-common toolchains:
  #   ld: libengine_gui.a(gui_menu.o):(.bss+0x0): multiple definition of
  #     `menu_t'; objs.release/action.o:(.bss+0x20): first defined here
  # TODO: remove it for 1.7.7+ release as it was fixed upstream.
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  buildFlags = [
    "PREFIX=${placeholder "out"}"
    "CFG=release"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 bin.release/klystrack $out/bin/klystrack

    mkdir -p $out/lib/klystrack
    cp -R res $out/lib/klystrack
    cp -R key $out/lib/klystrack

    install -DT icon/256x256.png $out/share/icons/hicolor/256x256/apps/klystrack.png
    mkdir -p $out/share/applications
    substitute linux/klystrack.desktop $out/share/applications/klystrack.desktop \
      --replace "klystrack %f" "$out/bin/klystrack %f"

    runHook postInstall
  '';

  meta = {
    description = "Chiptune tracker";
    homepage = "https://kometbomb.github.io/klystrack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ suhr ];
    platforms = lib.platforms.linux;
    mainProgram = "klystrack";
  };
})
