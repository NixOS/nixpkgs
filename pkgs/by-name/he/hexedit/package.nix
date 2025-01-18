{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hexedit";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "pixel";
    repo = "hexedit";
    rev = finalAttrs.version;
    hash = "sha256-fIgPbr7qmxyEga2YaAD0+NBM8LeDm/tVAq99ub7aiAI=";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ ncurses ];

  meta = with lib; {
    description = "View and edit files in hexadecimal or in ASCII";
    homepage = "http://rigaux.org/hexedit.html";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sigmanificient ];
    mainProgram = "hexedit";
  };
})
