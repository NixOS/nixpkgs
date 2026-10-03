{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  SDL2,
  SDL2_net,
  pkg-config,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opentyrian2000";
  version = "2000.20250408";

  src = fetchFromGitHub {
    owner = "KScl";
    repo = "opentyrian2000";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UFD2Lvx74lUJXwn0ht+0jpPn6kKhjjLY2mP8SGPj0ok=";
  };

  data = fetchzip {
    url = "https://www.camanis.net/tyrian/tyrian2000.zip";
    hash = "sha256-KiYFsbiHtqQCJpXzKL5jyFS+Ho25unqaLGES8+Yj1Nw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    SDL2
    SDL2_net
  ];

  __structuredAttrs = true;
  strictDeps = true;
  enableParallelBuilding = true;

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postInstall = ''
    mkdir -p $out/share/games/opentyrian2000
    cp -r $data/* $out/share/games/opentyrian2000/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = ''Open source port of the game "Tyrian 2000"'';
    homepage = "https://github.com/KScl/opentyrian2000";
    mainProgram = "opentyrian2000";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; [
      gpl2Plus
      unfree
    ]; # freeware data assets
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ iedame ];
  };
})
