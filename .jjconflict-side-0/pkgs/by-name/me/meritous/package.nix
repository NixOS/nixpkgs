{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  SDL,
  SDL_image,
  SDL_mixer,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "meritous";
  version = "1.5";

  src = fetchFromGitLab {
    owner = "meritous";
    repo = "meritous";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-6KK2anjX+fPsYf4HSOHQ0EQBINqZiVbxo1RmBR6pslg=";
  };

  patches = [
    # Fix stack overflow on too long files:
    #   https://gitlab.com/meritous/meritous/-/merge_requests/5
    (fetchpatch {
      name = "fix-overflow.patch";
      url = "https://gitlab.com/meritous/meritous/-/commit/68029f02ccaea86fb96d6dd01edb269ac3e6eff0.patch";
      hash = "sha256-YRV0cEcn6nEJUdHF/cheezNbsgZmjy0rSUw0tuhUYf0=";
    })
  ];

  prePatch = ''
    substituteInPlace Makefile \
      --replace "prefix=/usr/local" "prefix=$out" \
      --replace sdl-config ${lib.getDev SDL}/bin/sdl-config
  '';

  buildInputs = [
    SDL
    SDL_image
    SDL_mixer
    zlib
  ];

  installPhase = ''
    runHook preInstall

    install -m 555 -D meritous $out/bin/meritous
    mkdir -p $out/share/meritous
    cp -r dat/* $out/share/meritous/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Action-adventure dungeon crawl game";
    homepage = "https://gitlab.com/meritous/meritous";
    changelog = "https://gitlab.com/meritous/meritous/-/blob/master/NEWS";
    license = licenses.gpl3Only;
    mainProgram = "meritous";
    maintainers = [ maintainers.alexvorobiev ];
    platforms = platforms.linux;
  };
})
