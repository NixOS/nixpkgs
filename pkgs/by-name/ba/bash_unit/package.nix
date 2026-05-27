{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bash_unit";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "bash-unit";
    repo = "bash_unit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uRUqa6sXaXXDes9JjyTsMlA+nYdTGdioM0/y2XDIiEw=";
  };

  patchPhase = ''
    runHook prePatch

    patchShebangs bash_unit

    for t in tests/test_*; do
      chmod +x "$t" # make test file visible to `patchShebangs`
      patchShebangs "$t"
      chmod -x "$t"
    done

    runHook postPatch
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    ./bash_unit ./tests/test_core.sh

    runHook postCheck
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bash_unit $out/bin/
  '';

  meta = {
    description = "Bash unit testing enterprise edition framework for professionals";
    maintainers = with lib.maintainers; [ pamplemousse ];
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3Plus;
    mainProgram = "bash_unit";
  };
})
