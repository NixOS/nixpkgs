{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "adslib";
  version = "unstable-2020-08-28";

  src = fetchFromGitHub {
    owner = "stlehmann";
    repo = "ADS";
    rev = "c457b60d61d73325837ca50be2cc997c4792d481";
    hash = "sha256-c5A/4oXr/ne8AA2loMD4VqBwOrJLgQZPSZ9kh1Q3KIc=";
  };

  installPhase = ''
    mkdir -p $out/lib
    cp adslib.so $out/lib/adslib.so
  '';

  meta = {
    description = "Beckhoff protocol to communicate with TwinCAT devices";
    homepage = "https://github.com/stlehmann/ADS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}
