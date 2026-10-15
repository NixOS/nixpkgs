{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wolfram-for-jupyter-kernel";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "WolframResearch";
    repo = "WolframLanguageForJupyter";
    rev = "v${finalAttrs.version}";
    hash = "sha256-h7he/TuXJcffy96m0eKB5x8FzSmOzIo68PHsBfJuqaU=";
  };

  dontConfigure = true;

  installPhase = ''
    patchShebangs ./configure-jupyter.wls
    mkdir -p $out/share/Wolfram
    cp -r {WolframLanguageForJupyter,images,extras,LICENSE} $out/share/Wolfram
  '';

  # no tests
  doCheck = false;

  meta = {
    description = "Jupyter kernel for Wolfram Language";
    homepage = "https://github.com/WolframResearch/WolframLanguageForJupyter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fbeffa ];
    platforms = lib.platforms.all;
  };
})
