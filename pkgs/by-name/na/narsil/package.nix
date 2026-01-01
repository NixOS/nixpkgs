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
  SDL2_mixer,
  SDL2_ttf,
}:
stdenv.mkDerivation rec {
  pname = "narsil";
<<<<<<< HEAD
  version = "1.4.0-112-gaa252eb26";
=======
  version = "1.4.0-93-g3d8664466";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "NickMcConnell";
    repo = "NarSil";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-FqWoyq6FFCknT29Zkrkozi0+2JkrhJ2fKXVSbh5ZWXo=";
=======
    hash = "sha256-PsSotj2lkQcgyQ1rSJpuH+TvTWehgJsI9nWhDrQ/4Zk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  passthru.updateScript = nix-update-script { };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    ncurses
  ]
  ++ lib.optionals enableSdl2 [
    SDL2
    SDL2_image
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
