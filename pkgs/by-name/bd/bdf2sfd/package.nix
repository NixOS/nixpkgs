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
    rev = version;
    sha256 = "sha256-L1fIPZdVP4px73VbnEA6sb28WrmsNUJ2tqLeGPpwDbA=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "BDF to SFD converter";
    homepage = "https://github.com/fcambus/bdf2sfd";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "bdf2sfd";
  };
}
