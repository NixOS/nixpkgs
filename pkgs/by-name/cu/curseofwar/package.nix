{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  SDL,
  enableNcurses ? true,
  enableSDL ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "curseofwar";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "a-nikolaev";
    repo = "curseofwar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MXwayZCpLct5kcBrd2L75BFkRvcB1ZJaeT8maRsPp/E=";
  };

  nativeBuildInputs = lib.optionals enableSDL [ SDL ]; # for sdl-config during build time

  buildInputs = lib.optionals enableNcurses [ ncurses ] ++ lib.optionals enableSDL [ SDL ];

  strictDeps = true;

  assertions = [
    (lib.asserts.assertMsg (
      enableNcurses != enableSDL
    ) "Exactly one display frontend (enableNcurses or enableSDL) must be enabled")
  ];

  makeFlags = (lib.optionals enableSDL [ "SDL=yes" ]) ++ [
    "PREFIX=$(out)"
    # force platform's cc on darwin, otherwise gcc is used
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  meta = {
    description = "Fast-paced action strategy game";
    homepage = "https://a-nikolaev.github.io/curseofwar/";
    license = lib.licenses.gpl3Plus;
    mainProgram = if enableSDL then "curseofwar-sdl" else "curseofwar";
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
})
