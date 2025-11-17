{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quantlib";
  version = "1.40";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "lballabio";
    repo = "QuantLib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cyri+kCwIFO/ccnqWhO8qOXNPIV0g6iiNvBYtN667pA=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost ];

  # Required by RQuantLib, may be beneficial for others too
  cmakeFlags = [ "-DQL_HIGH_RESOLUTION_DATE=ON" ];

  # Needed for RQuantLib and possible others
  postInstall = ''
    cp ./quantlib-config $out/bin/
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Free/open-source library for quantitative finance";
    homepage = "https://quantlib.org";
    changelog = "https://github.com/lballabio/QuantLib/releases/tag/v${finalAttrs.version}";
    platforms = platforms.unix;
    license = licenses.bsd3;
    maintainers = [ maintainers.kupac ];
  };
})
