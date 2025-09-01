{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "edlib";
  version = "1.3.9.post1";

  src = fetchFromGitHub {
    owner = "Martinsos";
    repo = "edlib";
    tag = finalAttrs.version;
    hash = "sha256-XejxohLVdBBzpYZ//OpqC1ActmCaZ8tunJyhOYtZmKQ=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    bin/runTests
    runHook postCheck
  '';

  meta = {
    homepage = "https://martinsos.github.io/edlib";
    description = "Lightweight, fast C/C++ library for sequence alignment using edit distance";
    maintainers = with lib.maintainers; [ bcdarwin ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
