{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pacman4console";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "YoctoForBeaglebone";
    repo = "pacman4console";
    rev = "ddc229c3478b43b572cef4fc09bb1580f00a1e74";
    hash = "sha256-kdf9zzlz6jv6ZvRVVwFNQ7F4TjBCsy+G+aZfWMOwkQ8=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'gcc ' '$(CC) '
  '';

  strictDeps = true;
  enableParallelBuilding = true;

  buildInputs = [ ncurses ];

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    "-std=gnu89"
  ];

  meta = {
    description = "Console version of Pac-Man";
    homepage = "https://github.com/YoctoForBeaglebone/pacman4console";
    changelog = "https://github.com/YoctoForBeaglebone/pacman4console/blob/master/ChangeLog";
    license = lib.licenses.gpl2Only;
    mainProgram = "pacman";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})
