{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openal,
  sdl2-compat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bstone";
  version = "1.3.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "bibendovsky";
    repo = "bstone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8ifvHNf+vUtoffxghMwFXpGuarMEEBF+bkSbE4M9zf0=";
  };

  # dlopen'd
  postPatch = ''
    substituteInPlace src/bstone/src/bstone_oal_audio_mixer.cpp \
      --replace-fail '"libopenal.so"' '"${lib.getLib openal}/lib/libopenal${stdenv.hostPlatform.extensions.sharedLibrary}"'
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    openal
    sdl2-compat
  ];

  postInstall = ''
    mkdir -p $out/{bin,share/bibendovsky/bstone}
    mv $out/bstone $out/bin
    mv $out/*.txt $out/share/bibendovsky/bstone
  '';

  meta = {
    description = "Unofficial source port for the Blake Stone series";
    homepage = "https://bibendovsky.github.io/bstone";
    changelog = "https://github.com/bibendovsky/bstone/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl2Plus # Original game source code
      mit # BStone
    ];
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux; # TODO: macOS / Darwin support
    mainProgram = "bstone";
  };
})
