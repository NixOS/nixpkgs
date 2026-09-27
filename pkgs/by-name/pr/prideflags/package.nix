{
  stdenv,
  lib,
  fetchFromGitHub,
  ...
}:
stdenv.mkDerivation {
  pname = "prideflag";
  version = "0-unstable-2022-08-10";

  src = fetchFromGitHub {
    owner = "CharlotteCross1998";
    repo = "prideflags";
    rev = "968fd9a89b67bd1675da86ef955e728f828a6060";
    sha256 = "sha256-jiA9c+8VkaULLAFFrK+XF3VV/bRoKFm37iA9H3ZmZRA=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  patches = [ ./fix_path.patch ];

  meta = with lib; {
    description = "Print pride flags on the terminal!";
    homepage = "https://github.com/CharlotteCross1998/prideflags";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ emo-mruczek ];
    mainProgram = "prideflag";
  };
}
