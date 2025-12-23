{
  lib,
  stdenv,
  fetchFromGitHub,
  gitMinimal,
  cacert,
  makeBinaryWrapper,
  nodejs,
  python3,
  nixosTests,
  yarn-berry_4,
  writableTmpDirAsHomeHook,
}:

let
  version = "1.10.4";

  src = fetchFromGitHub {
    owner = "hedgedoc";
    repo = "hedgedoc";
    tag = version;
    hash = "sha256-ysiHvRMOgVFTFKeMWjshZpIZAOTf+EbBQQm3dDeMB3I=";
  };
  missingHashes = ./missing-hashes.json;

in
stdenv.mkDerivation {
  pname = "hedgedoc";
  inherit version src missingHashes;

  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit src missingHashes;
    hash = "sha256-jMJXNWvmlweCJu+xs2ucMtB6N+0r1cgP/aGt2zfH4iQ=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    (python3.withPackages (ps: with ps; [ setuptools ])) # required to build sqlite3 bindings
    yarn-berry_4
    yarn-berry_4.yarnBerryConfigHook
  ];

  buildInputs = [
    nodejs # for shebangs
  ];

  buildPhase = ''
    runHook preBuild

    yarn run build

    # Delete scripts that are not useful for NixOS
    rm bin/{heroku,setup}
    patchShebangs bin/*

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/hedgedoc
    cp -r {app.js,bin,lib,locales,node_modules,package.json,public} $out/share/hedgedoc

    for bin in $out/share/hedgedoc/bin/*; do
      makeWrapper $bin $out/bin/$(basename $bin) \
        --set NODE_ENV production \
        --set NODE_PATH "$out/share/hedgedoc/lib/node_modules"
    done
    makeWrapper ${nodejs}/bin/node $out/bin/hedgedoc \
      --add-flags $out/share/hedgedoc/app.js \
      --set NODE_ENV production \
      --set NODE_PATH "$out/share/hedgedoc/lib/node_modules"

    runHook postInstall
  '';

  passthru = {
    tests = { inherit (nixosTests) hedgedoc; };
  };

  meta = {
    description = "Realtime collaborative markdown notes on all platforms";
    license = lib.licenses.agpl3Only;
    homepage = "https://hedgedoc.org";
    mainProgram = "hedgedoc";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    platforms = lib.platforms.linux;
  };
}
