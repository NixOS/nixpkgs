{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "bdf2sfd";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "fcambus";
    repo = "bdf2sfd";
    tag = version;
    sha256 = "sha256-L1fIPZdVP4px73VbnEA6sb28WrmsNUJ2tqLeGPpwDbA=";
  };

  nativeBuildInputs = [ cmake ];

<<<<<<< HEAD
  meta = {
    description = "BDF to SFD converter";
    homepage = "https://github.com/fcambus/bdf2sfd";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "BDF to SFD converter";
    homepage = "https://github.com/fcambus/bdf2sfd";
    license = licenses.bsd2;
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    mainProgram = "bdf2sfd";
  };
}
