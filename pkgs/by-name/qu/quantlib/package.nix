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
  version = "1.41";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "lballabio";
    repo = "QuantLib";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dHXITHP0SBrBXf5hrVhjSD4n2EtVvEkBDfE2NbT0/sc=";
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

  meta = {
    description = "Free/open-source library for quantitative finance";
    homepage = "https://quantlib.org";
    changelog = "https://github.com/lballabio/QuantLib/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.kupac ];
  };
})
