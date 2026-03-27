{
  stdenv,
  lib,
  fetchFromGitHub,
  chez,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chez-matchable";
  # nixpkgs-update: no auto update
  version = "0.2";

  src = fetchFromGitHub {
    owner = "fedeinthemix";
    repo = "chez-matchable";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-UYoT8Kp1FTfiL22ntrFXFcAB1HGVrJ6p9JgvhUKi+Yo=";
  };

  buildInputs = [ chez ];

  makeFlags = [
    "CHEZ=${lib.getExe chez}"
    "PREFIX=$(out)"
  ];

  doCheck = false;

  meta = {
    description = "Library for ChezScheme providing the portable hygenic pattern matcher by Alex Shinn";
    homepage = "https://github.com/fedeinthemix/chez-matchable/";
    maintainers = [ lib.maintainers.jitwit ];
    license = lib.licenses.publicDomain;
  };

})
