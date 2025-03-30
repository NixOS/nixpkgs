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
  version = "7c20b01e055491e86a44201504e8d36873ef1822";

  src = fetchFromGitHub {
    owner = "NickMcConnell";
    repo = "NarSil";
    rev = version;
    hash = "sha256-6J9WCWXhKiTRLiH08DTGzAXe8QZFQOLYJkfNVONgWU0=";
  };

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

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
    maintainers = with lib.maintainers; [
      nanotwerp
      x123
    ];
    license = lib.licenses.gpl2;
  };
}
