{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation rec {
  version = "1.5.0";
  pname = "smenu";

  src = fetchFromGitHub {
    owner = "p-gen";
    repo = "smenu";
    rev = "v${version}";
    sha256 = "sha256-nTQe6sCMHGRW7Djpv33xY8nL4a7ZyC9YM7PGOvmpuSM=";
  };

  buildInputs = [ ncurses ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/p-gen/smenu";
    description = "Terminal selection utility";
    longDescription = ''
      Terminal utility that allows you to use words coming from the standard
      input to create a nice selection window just below the cursor. Once done,
      your selection will be sent to standard output.
    '';
<<<<<<< HEAD
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    platforms = lib.platforms.unix;
=======
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "smenu";
  };
}
