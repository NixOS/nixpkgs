{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm,
  nix-update-script,
  fetchurl,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "synchrony";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "relative";
    repo = "synchrony";
    rev = finalAttrs.version;
    hash = "sha256-nJ6H1SZAQCG6U3BPEPmm+BGQa8Af+Vb1E+Lv8lIqDBE=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-+hS4UK7sncCxv6o5Yl72AeY+LSGLnUTnKosAYB6QsP0=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 dist/{index,cli}.js -t $out/share/synchrony
    cp -r node_modules $out/share/synchrony
    ln -s $out/share/synchrony/cli.js $out/bin/synchrony

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    substituteInPlace $out/share/synchrony/cli.js \
      --replace-fail "require('../')" "require('$out/share/synchrony')"
    patchShebangs $out/share/synchrony/cli.js

    runHook postFixup
  '';

  passthru = {
    tests.deobfuscate =
      let
        obfuscated = fetchurl {
          url = "https://gist.github.com/relative/79e392bced4b9bed8fd076f834e06dee/raw/obfuscated.js";
          hash = "sha256-AQWKVIyb6x3wWG3bMMqIJWsV26S9W5Xd+QVB26zu8LA=";
        };
      in
      runCommand "synchrony-test" { } ''
        mkdir -p $out
        ${lib.getExe finalAttrs.finalPackage} deobfuscate ${obfuscated} -o $out/deobfuscated.js
      '';

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Simple deobfuscator for mangled or obfuscated JavaScript files";
    homepage = "https://deobfuscate.relative.im/";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ pluiedev ];
    inherit (nodejs.meta) platforms;
    mainProgram = "synchrony";
  };
})
