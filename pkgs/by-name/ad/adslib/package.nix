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
    sha256 = "11r86xa8fr4z957hd0abn8x7182nz30a198d02y7gzpbhpi3z43k";
  };

  installPhase = ''
    mkdir -p $out/lib
    cp adslib.so $out/lib/adslib.so
  '';

  meta = with lib; {
    description = "Beckhoff protocol to communicate with TwinCAT devices";
    homepage = "https://github.com/stlehmann/ADS";
    license = licenses.mit;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
