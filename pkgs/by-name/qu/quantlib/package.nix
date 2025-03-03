{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quantlib";
  version = "1.37";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "lballabio";
    repo = "QuantLib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Q8Bz94yd4A0VCDldtiichFKgiZMN4dHHJJep/tcE/z0=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];

  # Required by RQuantLib, may be beneficial for others too
  cmakeFlags = [ "-DQL_HIGH_RESOLUTION_DATE=ON" ];

  # Needed for RQuantLib and possible others
  postInstall = ''
    cp ./quantlib-config $out/bin/
  '';

  meta = with lib; {
    description = "Free/open-source library for quantitative finance";
    homepage = "https://quantlib.org";
    changelog = "https://github.com/lballabio/QuantLib/releases/tag/v${finalAttrs.version}";
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = [ maintainers.kupac ];
  };
})
