{
  stdenv,
  mkDerivation,
  lib,
  fetchFromBitbucket,
  cmake,
  qtbase,
  qttools,
}:

mkDerivation rec {
  pname = "speedcrunch";
  version = "unstable-2021-10-09";

  src = fetchFromBitbucket {
    owner = "heldercorreia";
    repo = pname;
    rev = "74756f3438149c01e9edc3259b0f411fa319a22f";
    sha256 = "sha256-XxQv+A5SfYXFIRK7yacxGHHne1Q93pwCGeHhchIKizU=";
  };

  buildInputs = [
    qtbase
    qttools
  ];

  nativeBuildInputs = [ cmake ];

  preConfigure = ''
    cd src
  '';

  meta = with lib; {
    homepage = "http://speedcrunch.org";
    license = licenses.gpl2Plus;
    description = "Fast power user calculator";
    mainProgram = "speedcrunch";
    longDescription = ''
      SpeedCrunch is a fast, high precision and powerful desktop calculator.
      Among its distinctive features are a scrollable display, up to 50 decimal
      precisions, unlimited variable storage, intelligent automatic completion
      full keyboard-friendly and more than 15 built-in math function.
    '';
    maintainers = with maintainers; [
      gebner
      j0hax
    ];
    inherit (qtbase.meta) platforms;
    broken = stdenv.hostPlatform.isDarwin;
  };
}
