{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mathjax";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "mathjax";
    repo = "mathjax";
    tag = finalAttrs.version;
    hash = "sha256-36lTjx4zuFeT1+QFemiQcCZfAjyh7vFPpYeRhO2mzGI=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/mathjax
    mv * $out/lib/node_modules/mathjax
    # This is a MathJax v3 compat shim, notably still needed for sagemath
    ln -s $out/lib/node_modules/mathjax $out/lib/node_modules/mathjax/es5

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/mathjax/MathJax/releases/tag/${finalAttrs.version}";
    description = "Beautiful and accessible math in all browsers";
    homepage = "https://www.mathjax.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
