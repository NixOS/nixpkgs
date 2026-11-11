{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libuldaq";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "mccdaq";
    repo = "uldaq";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-+UNICbbhPk9yJIeC2w8d3q5OPrWrDFZ2cvZsbn6dNgQ=";
  };

  patches = [
    # Patch needed for `make install` to succeed
    ./0001-uldaq.patch
  ];

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ libusb1 ];

  doInstallCheck = true;

  meta = {
    description = "Library to talk to uldaq devices";
    longDescription = ''
      Library used to communicate with USB data acquisition (DAQ)
      devices from Measurement Computing
    '';
    homepage = "https://github.com/mccdaq/uldaq";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.simonkampe ];
  };
})
