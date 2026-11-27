{
  lib,
  fetchFromGitHub,
  leanPackages,
}:

leanPackages.buildLakePackage (finalAttrs: {
  pname = "con-leche";
  version = "0-unstable-2026-10-05";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "con-leche";
    # https://github.com/leanprover/lean4/blob/v{version}/src/CMakeLists.txt
    rev = "67f04630d88718e81aa4d07ab64501f68f105398";
    hash = "sha256-3tkuAcAeljQNY2D1CdukMDGdY/5a3nM96JKHHUPpyy8=";
  };

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    lake test

    runHook postCheck
  '';

  # bwrap: Can't mount on symlink destination
  postInstall = ''
    rm $out/bin/con-leche
    ln $out/.lake/build/bin/con-leche -T $out/bin/con-leche
  '';

  meta = with lib; {
    description = "External lean checker with a proof of consistency";
    homepage = "https://github.com/leanprover/con-leche";
    license = licenses.asl20;
    mainProgram = "con-leche";
    maintainers = with maintainers; [ stephen-huan ];
  };
})
