{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  ncurses,
  which,
}:

stdenv.mkDerivation rec {
  pname = "progress";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "Xfennec";
    repo = "progress";
    rev = "v${version}";
    sha256 = "sha256-riewkageSZIlwDNMjYep9Pb2q1GJ+WMXazokJGbb4bE=";
  };

  nativeBuildInputs = [
    pkg-config
    which
  ];
  buildInputs = [ ncurses ];

  makeFlags = [ "PREFIX=$(out)" ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/Xfennec/progress";
    description = "Tool that shows the progress of coreutils programs";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ pSub ];
=======
  meta = with lib; {
    homepage = "https://github.com/Xfennec/progress";
    description = "Tool that shows the progress of coreutils programs";
    license = licenses.gpl3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pSub ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "progress";
  };
}
