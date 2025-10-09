{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sdl2-compat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bstone";
  version = "1.2.16";

  src = fetchFromGitHub {
    owner = "bibendovsky";
    repo = "bstone";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6BNIMBbLBcQoVx5lnUz14viAvBcFjoZLY8c30EgcvKQ=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    sdl2-compat
  ];

  postInstall = ''
    mkdir -p $out/{bin,share/bibendovsky/bstone}
    mv $out/bstone $out/bin
    mv $out/*.txt $out/share/bibendovsky/bstone
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
