{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "banner";
  version = "1.3.6";

  src = fetchFromGitHub {
    owner = "pronovic";
    repo = "banner";
    rev = "BANNER_V${version}";
    sha256 = "sha256-g9i460W0SanW2xIfZk9Am/vDsRlL7oxJOUhksa+I8zY=";
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/pronovic/banner";
    description = "Print large banners to ASCII terminals";
    mainProgram = "banner";
    license = lib.licenses.gpl2Only;
=======
  meta = with lib; {
    homepage = "https://github.com/pronovic/banner";
    description = "Print large banners to ASCII terminals";
    mainProgram = "banner";
    license = licenses.gpl2Only;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    longDescription = ''
      An implementation of the traditional Unix-program used to display
      large characters.
    '';

<<<<<<< HEAD
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pSub ];
=======
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
