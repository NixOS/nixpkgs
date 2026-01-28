{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  sdl2-compat,
  vulkan-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bstone";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "bibendovsky";
    repo = "bstone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D0f4DmVv2Bo3cwCUuo3LsXNWFR16rirpvSnAS2C6YEY=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    sdl2-compat
    vulkan-loader
  ];

  postInstall = ''
    mkdir -p $out/{bin,share/bibendovsky/bstone}
    mv $out/bstone $out/bin
    mv $out/*.txt $out/share/bibendovsky/bstone

    wrapProgram $out/bin/bstone \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = {
    description = "Unofficial source port for the Blake Stone series";
    homepage = "https://github.com/bibendovsky/bstone";
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
