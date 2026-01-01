{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "pixd";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "FireyFly";
    repo = "pixd";
    rev = "v${version}";
    sha256 = "1vmkbs39mg5vwmkzfcrxqm6p8zr9sj4qdwng9icmyf5k34c34xdg";
  };

  makeFlags = [ "PREFIX=$(out)" ];

<<<<<<< HEAD
  meta = {
    description = "Colourful visualization tool for binary files";
    homepage = "https://github.com/FireyFly/pixd";
    maintainers = [ lib.maintainers.FireyFly ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Colourful visualization tool for binary files";
    homepage = "https://github.com/FireyFly/pixd";
    maintainers = [ maintainers.FireyFly ];
    license = licenses.mit;
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "pixd";
  };
}
