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
  version = "0.44";

  src = fetchFromGitHub {
    owner = "lojban";
    repo = "jbofihe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Aybnpm93URikXrqmYnikzFo9vxm9j/MNdxoil6l41Uw=";
  };

  patches = [
    # fix linking on aarch64-darwin:
    # https://github.com/lojban/jbofihe/pull/21
    ./fix-unaligned-pointers.patch
  ];

  nativeBuildInputs = [
    bison
    flex
    perl
  ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

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
