{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "pick";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "mptre";
    repo = "pick";
    rev = "v${version}";
    sha256 = "8cgt5KpLfnLwhucn4DQYC/7ot1u24ahJxWG+/1SL584=";
  };

  buildInputs = [ ncurses ];

  PREFIX = placeholder "out";

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Fuzzy text selection utility";
    license = licenses.mit;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "pick";
  };

}
