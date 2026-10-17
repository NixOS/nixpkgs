{
  lib,
  stdenv,
  fetchFromGitHub,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openlibm";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "JuliaMath";
    repo = "openlibm";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-vBy7VhYPmmaIbDN6SAXkbbM2xDh1XiIqEnYpnzop+Zg=";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  makeFlags = [
    "prefix=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  meta = {
    description = "High quality system independent, portable, open source libm implementation";
    homepage = "https://openlibm.org/";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
