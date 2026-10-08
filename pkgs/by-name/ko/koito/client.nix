{
  src,
  version,
  stdenv,
  yarn-berry_4,
  nodejs,
  gzip,
}:
let
  yarn = yarn-berry_4;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "koito-frontend";
  inherit src version;
  sourceRoot = "${finalAttrs.src.name}/client";

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn.fetchYarnBerryDeps {
    inherit (finalAttrs) src sourceRoot missingHashes;
    hash = "sha256-VIlWld21GScJ/2UUkKQISM9jyU9wCVwwDNKkge+K044=";
  };

  nativeBuildInputs = [
    nodejs
    yarn.yarnBerryConfigHook
    yarn
    gzip
  ];

  buildPhase = ''
    runHook preBuild
    export VITE_KOITO_VERSION=${version}
    yarn run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/client
    cp -r build $out/client

    find $out/client/build -type f \( -name "*.js" -o -name "*.css" -o -name "*.html" -o -name "*.svg" \) -exec gzip -k -9 {} \;

    runHook postInstall
  '';
})
