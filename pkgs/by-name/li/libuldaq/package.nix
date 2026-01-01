{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libusb1,
}:

stdenv.mkDerivation rec {
  pname = "libuldaq";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "mccdaq";
    repo = "uldaq";
    rev = "v${version}";
    sha256 = "sha256-DA1mxu94z5xDpGK9OBwD02HXlOATv/slqZ4lz5GM7QM=";
  };

  patches = [
    # Patch needed for `make install` to succeed
    ./0001-uldaq.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libusb1 ];

  doInstallCheck = true;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Library to talk to uldaq devices";
    longDescription = ''
      Library used to communicate with USB data acquisition (DAQ)
      devices from Measurement Computing
    '';
    homepage = "https://github.com/mccdaq/uldaq";
<<<<<<< HEAD
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.simonkampe ];
=======
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ maintainers.simonkampe ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
