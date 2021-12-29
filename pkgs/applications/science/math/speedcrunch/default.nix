{ mkDerivation, lib, fetchFromBitbucket, cmake, qtbase, qttools }:

mkDerivation rec {
  pname = "speedcrunch";
  version = "0.12.0";

  src = fetchFromBitbucket {
    owner = "heldercorreia";
    repo = pname;
    rev = "release-${version}";
    sha256 = "0vh7cd1915bjqzkdp3sk25ngy8cq624mkh8c53c5bnzk357kb0fk";
  };

  buildInputs = [ qtbase qttools ];

  nativeBuildInputs = [ cmake ];

  preConfigure = ''
    cd src
  '';

  meta = with lib; {
    homepage    = "http://speedcrunch.org";
    license     = licenses.gpl2Plus;
    description = "A fast power user calculator";
    longDescription = ''
      SpeedCrunch is a fast, high precision and powerful desktop calculator.
      Among its distinctive features are a scrollable display, up to 50 decimal
      precisions, unlimited variable storage, intelligent automatic completion
      full keyboard-friendly and more than 15 built-in math function.
    '';
    maintainers = with maintainers; [ gebner j0hax ];
    inherit (qtbase.meta) platforms;
    # works with qt 5.6 and qt 5.8
    broken = builtins.compareVersions qtbase.version "5.7.0" == 0;
  };
}
