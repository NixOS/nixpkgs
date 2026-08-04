{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  nodejs,
  dart-sass,
  pnpm_11,
  pnpmConfigHook,
  fetchPnpmDeps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frequi";
  version = "3.1.0";
  src = fetchFromGitHub {
    owner = "freqtrade";
    repo = "frequi";
    tag = finalAttrs.version;
    hash = "sha256-Z8qG/N2Njy/Ya69y8rN7+V309HnoeHjn0yZqGXx2Sxw=";
  };
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_11; # https://github.com/freqtrade/frequi/blob/7d8a81c1022fa39dffbcd69f45a01767259dd4de/package.json#L68
    fetcherVersion = 4;
    hash = "sha256-nA3Kpa1aaWA+9gIFvtuZP5IPT5eSbd0NtOAojLSYkmQ=";
  };
  nativeBuildInputs = [
    git # https://github.com/freqtrade/frequi/blob/7d8a81c1022fa39dffbcd69f45a01767259dd4de/vite.config.ts#L12
    nodejs
    pnpm_11
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
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ n0099 ];
  };
})
