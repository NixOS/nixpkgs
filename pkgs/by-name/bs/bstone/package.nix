{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  sdl2-compat,
  vulkan-loader,
  openal,
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

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    sdl2-compat
  ];

  postInstall = ''
    mkdir -p $out/{bin,share/bibendovsky/bstone}
    mv $out/bstone $out/bin
    mv $out/*.txt $out/share/bibendovsky/bstone

    wrapProgram $out/bin/bstone \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          openal
          vulkan-loader
        ]
      }
  '';

  meta = {
    description = "Unofficial source port for the Blake Stone series";
    homepage = "https://bibendovsky.github.io/bstone";
    changelog = "https://github.com/bibendovsky/bstone/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      gpl2Plus # Original game source code
      mit # BStone
    ];
    maintainers = with lib.maintainers; [ keenanweaver ];
    mainProgram = "bstone";
    platforms = lib.platforms.linux; # TODO: macOS / Darwin support
  };
})
