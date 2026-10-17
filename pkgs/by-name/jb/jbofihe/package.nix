{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jbofihe";
  version = "0.43";

  src = fetchFromGitHub {
    owner = "lojban";
    repo = "jbofihe";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KN1AhvNpm08Vrj5q8D+y25BCpaHSFNO/Z1ZqU0Top/c=";
  };

  patches = [
    # fix build with gcc14:
    # https://github.com/lojban/jbofihe/pull/19
    ./fix-gcc14-errors.patch
  ];

  nativeBuildInputs = [
    bison
    flex
    perl
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    (cd tests && ./run *.in)
    runHook postCheck
  '';

  meta = {
    description = "Parser & analyser for Lojban";
    homepage = "https://github.com/lojban/jbofihe";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ chkno ];
  };
})
