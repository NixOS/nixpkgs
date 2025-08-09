{
  lib,
  stdenv,
  fetchFromGitHub,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation rec {
  pname = "openlibm";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "JuliaLang";
    repo = "openlibm";
    rev = "v${version}";
    sha256 = "sha256-fSEszCJ1PXkSydTLk8KAyu7zffUrKf+7a1ZDf3Wl/lE=";
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
    maintainers = [ lib.maintainers.ttuegel ];
    platforms = lib.platforms.all;
  };
}
