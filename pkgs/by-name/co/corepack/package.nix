{ lib, stdenvNoCC, fetchurl, nodejs-slim }:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "corepack";
  version = "0.22.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/corepack/-/corepack-${finalAttrs.version}.tgz";
    hash = "sha256-sQJluWw7yyIjII64DcXrbO1lhXBy07qv09VBZhuPwHs=";
  };

  buildInputs = [ nodejs-slim ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/ $out/lib/node_modules/corepack/
    mv package.json dist $out/lib/node_modules/corepack/
    for f in $out/lib/node_modules/corepack/dist/*.js; do
      ln -s $f $out/bin/$(basename $f .js)
    done

    runHook postInstall
  '';

  meta = {
    description = "Package acting as bridge between Node projects and their package managers";
    homepage = "https://github.com/nodejs/corepack";
    changelog = "https://github.com/nodejs/corepack/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wmertens ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
