{ lib, stdenv, fetchFromGitLab, SDL, SDL_image, SDL_mixer, zlib }:

stdenv.mkDerivation (finalAttrs: {
  pname = "meritous";
  version = "1.5";

  src = fetchFromGitLab {
    owner = "meritous";
    repo = "meritous";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-6KK2anjX+fPsYf4HSOHQ0EQBINqZiVbxo1RmBR6pslg=";
  };

  prePatch = ''
    substituteInPlace Makefile \
      --replace "prefix=/usr/local" "prefix=$out" \
      --replace sdl-config ${lib.getDev SDL}/bin/sdl-config

    substituteInPlace src/audio.c \
      --replace "filename[64]" "filename[256]"
  '';

  buildInputs = [ SDL SDL_image SDL_mixer zlib ];

  installPhase = ''
    install -m 555 -D meritous $out/bin/meritous
    mkdir -p $out/share/meritous
    cp -r dat/* $out/share/meritous/
  '';

  hardeningDisable = [ "stackprotector" "fortify" ];

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
