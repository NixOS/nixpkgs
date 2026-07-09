{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  nodejs,
  dart-sass,
  pnpm_12,
  pnpmConfigHook,
  fetchPnpmDeps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frequi";
  version = "3.2.1";
  src = fetchFromGitHub {
    owner = "freqtrade";
    repo = "frequi";
    tag = finalAttrs.version;
    hash = "sha256-Z3gW8+rPYM/THdS2jgo44xCW1XUIj5TDAEFqsa31mC4=";
  };
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_12; # https://github.com/freqtrade/frequi/blob/fc11114c1ba6d6d412137bc4f6f60c7ad7cd1ab7/package.json#L68
    fetcherVersion = 4;
    hash = "sha256-ltrRILUNgyBzg5U6RLGq5fZ0K34dnynDFxmpBUPdMiQ=";
  };
  nativeBuildInputs = [
    git # https://github.com/freqtrade/frequi/blob/7d8a81c1022fa39dffbcd69f45a01767259dd4de/vite.config.ts#L12
    nodejs
    pnpm_12
    pnpmConfigHook
  ];
  buildPhase = ''
    # https://github.com/sass/embedded-host-node/issues/334
    substituteInPlace node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'
    mkdir $out
    pnpm run build --outDir $out
  '';
  meta = {
    description = "Freqtrade UI - Frontend for Freqtrade";
    homepage = "https://github.com/freqtrade/frequi";
    changelog = "https://github.com/freqtrade/frequi/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ n0099 ];
  };
})
