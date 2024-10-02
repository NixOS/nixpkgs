{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  nix-update-script,
  ncurses,
  enableSdl2 ? true,
  SDL2,
  SDL2_image,
  SDL2_sound,
  SDL2_mixer,
  SDL2_ttf,
}:
stdenv.mkDerivation rec {
  pname = "narsil";
  version = "1.3.0-234-g228c4f0cb";

  src = fetchFromGitHub {
    owner = "NickMcConnell";
    repo = "NarSil";
    rev = version;
    hash = "sha256-82ph8LTtaruaV97gdnqSQI8IfqO9wzYbR7WTGx086pQ=";
  };

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs =
    [ ncurses ]
    ++ lib.optionals enableSdl2 [
      SDL2
      SDL2_image
      SDL2_sound
      SDL2_mixer
      SDL2_ttf
    ];

  enableParallelBuilding = true;

  configureFlags = lib.optional enableSdl2 "--enable-sdl2";

  installFlags = [ "bindir=$(out)/bin" ];

  meta = {
    homepage = "https://github.com/NickMcConnell/NarSil/";
    description = "Unofficial rewrite of Sil, a roguelike influenced by Angband";
    mainProgram = "narsil";
    changelog = "https://github.com/NickMcConnell/NarSil/releases/tag/${version}";
    longDescription = ''
      NarSil attempts to be an almost-faithful recreation of Sil 1.3.0,
      but based on the codebase of modern Angband.
    '';
    maintainers = with lib.maintainers; [ nanotwerp x123 ];
    license = lib.licenses.gpl2;
  };
}
