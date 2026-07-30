{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:
stdenv.mkDerivation {
  pname = "cpond";
  version = "0-unstable-2025-11-23";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ayuzur";
    repo = "cpond";
    rev = "b6d2827c73080b144ff07a70ec61757baff6a73b";
    hash = "sha256-feRGJ2CIa82eEiGG65WwFlh6dhhIvhW70FJMObWvi1Q=";
  };

  buildInputs = [ ncurses ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '$(eflags)$(ncursesw_macros)' '$(eflags) $(ncursesw_macros)'
  ''
  + lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile \
      --replace-fail '-lncursesw' '-lncurses'
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp cpond $out/bin/
  '';

  meta = {
    homepage = "https://github.com/ayuzur/cpond";
    description = "Procedurally animated fish for your terminal";
    license = lib.licenses.mit;
    mainProgram = "cpond";
    maintainers = with lib.maintainers; [ yarn ];
    platforms = lib.platforms.unix;
  };
}
