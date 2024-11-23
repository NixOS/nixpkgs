{
  version,
  src,
  stdenv,
  lib,
  pnpm_9,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit version src;

  pname = "rmfakecloud-webui";

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/ui";
    pnpmLock = "${src}/ui/pnpm-lock.yaml";
    hash = "sha256-VNmCT4um2W2ii8jAm+KjQSjixYEKoZkw7CeRwErff/o=";
  };
  pnpmRoot = "ui";

  buildPhase = ''
    cd ui

    # using sass-embedded fails at executing node_modules/sass-embedded-linux-x64/dart-sass/src/dart
    rm -r node_modules/sass-embedded node_modules/.pnpm/sass-embedded*

    pnpm build
  '';

  installPhase = ''
    cp -a dist/. $out
  '';

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
  ];

  meta = with lib; {
    description = "Only the webui files for rmfakecloud";
    homepage = "https://ddvk.github.io/rmfakecloud/";
    license = licenses.agpl3Only;
  };
})
