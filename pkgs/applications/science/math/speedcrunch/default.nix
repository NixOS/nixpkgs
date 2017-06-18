{ mkDerivation, lib, fetchgit, cmake, qtbase, qttools }:

mkDerivation rec {
  name = "speedcrunch-${version}";
  version = "0.12.0";

  src = fetchgit {
    # the tagging is not standard, so you probably need to check this when updating
    rev = "refs/tags/release-${version}";
    url = "https://bitbucket.org/heldercorreia/speedcrunch";
    sha256 = "0vh7cd1915bjqzkdp3sk25ngy8cq624mkh8c53c5bnzk357kb0fk";
  };

  buildInputs = [ qtbase qttools ];

  nativeBuildInputs = [ cmake ];

  preConfigure = ''
    cd src
  '';

  meta = with lib; {
    homepage    = http://speedcrunch.org;
    license     = licenses.gpl2Plus;
    description = "A fast power user calculator";
    longDescription = ''
      SpeedCrunch is a fast, high precision and powerful desktop calculator.
      Among its distinctive features are a scrollable display, up to 50 decimal
      precisions, unlimited variable storage, intelligent automatic completion
      full keyboard-friendly and more than 15 built-in math function.
    '';
    maintainers = with maintainers; [ gebner ];
    inherit (qtbase.meta) platforms;
    # works with qt 5.6 and qt 5.8
    broken = builtins.compareVersions qtbase.version "5.7.0" == 0;
  };
}
