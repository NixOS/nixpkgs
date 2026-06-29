{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  bison,
  flex,
  gmp,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scipopt-zimpl";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "zimpl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CUWLI12rH+NggQph+qWmWCTtbQubnhFKanuMlADLiHs=";
  };

  postPatch = ''
    chmod +x check/check.sh
  '';

  nativeBuildInputs = [
    cmake
    bison
    flex
  ];

  buildInputs = [
    gmp
    zlib
  ];
  doCheck = true;

  checkPhase = ''
    runHook preCheck
    pushd ../check
    ./check.sh ../build/bin/zimpl
    popd
    runHook postCheck
  '';
  meta = {
    maintainers = with lib.maintainers; [ pmeinhold ];
    platforms = lib.platforms.linux;
    broken = stdenv.hostPlatform.isDarwin;
    changelog = "https://zimpl.zib.de/download/CHANGELOG.txt";
    description = "Zuse Institute Mathematical Programming Language";
    longDescription = ''
      Zimpl is a little language to translate the mathematical model of a
      problem into a linear or nonlinear (mixed-)integer mathematical
      program expressed in .lp or .mps file format which can be read and
      (hopefully) solved by a LP or MIP solver.
    '';
    license = lib.licenses.lgpl3Plus;
    homepage = "https://zimpl.zib.de";
    mainProgram = "zimpl";
  };
})
